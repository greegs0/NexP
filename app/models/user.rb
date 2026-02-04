class User < ApplicationRecord
  include StatsCacheable

  # Plan constants
  PLANS = %w[free builder].freeze
  FREE_PROJECT_LIMIT = 1
  FREE_MESSAGE_LIMIT = 5

  # Chiffrement des tokens OAuth avec attr_encrypted
  attr_encrypted :oauth_token, key: Rails.application.credentials.encryption_key
  attr_encrypted :oauth_refresh_token, key: Rails.application.credentials.encryption_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :google_oauth2]

  # OmniAuth - Find or create user from OAuth data
  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # Try to find by email (link accounts)
    user = find_by(email: auth.info.email)
    if user
      user.update(provider: auth.provider, uid: auth.uid)
      return user
    end

    # Create new user
    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      username: generate_unique_username(auth),
      name: auth.info.name,
      github_username: (auth.info.nickname if auth.provider == 'github'),
      confirmed_at: Time.current # Auto-confirm OAuth users
    )
  end

  def self.generate_unique_username(auth)
    base = auth.info.nickname || auth.info.email.split('@').first
    base = base.gsub(/[^a-zA-Z0-9_]/, '_').downcase[0..25]
    username = base

    counter = 1
    while exists?(username: username)
      username = "#{base[0..(25 - counter.to_s.length)]}#{counter}"
      counter += 1
    end

    username
  end

  # Associations
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  # has_many :given_endorsements, class_name: 'SkillEndorsement', foreign_key: 'endorser_id', dependent: :destroy

  has_many :owned_projects, class_name: 'Project', foreign_key: 'owner_id', dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :projects, through: :teams

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', dependent: :destroy

  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges

  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'actor_id', dependent: :destroy

  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy
  has_many :following, through: :active_follows, source: :following
  has_many :followers, through: :passive_follows, source: :follower

  has_many :bookmarks, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "ne peut contenir que des lettres, chiffres et underscores" }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "doit contenir 5 chiffres" }, allow_blank: true
  validates :portfolio_url, :github_url, :linkedin_url,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "doit être une URL valide" },
            allow_blank: true
  validates :experience_points, numericality: { greater_than_or_equal_to: 0 }
  validates :level, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :plan, inclusion: { in: PLANS }

  # Callbacks
  before_save :normalize_username

  # Scopes
  scope :available, -> { where(available: true) }
  scope :with_skill, ->(skill_id) { joins(:user_skills).where(user_skills: { skill_id: skill_id }) }
  scope :by_level, ->(min_level) { where('level >= ?', min_level) }

  # Methods
  def display_name
    name.presence || username
  end

  def add_experience(points)
    increment!(:experience_points, points)
    level_up_if_needed
    check_badges
  end

  def check_badges
    BadgeService.check_and_award_badges(self)
  end

  def follow(other_user)
    active_follows.create(following: other_user) unless self == other_user
  end

  def unfollow(other_user)
    active_follows.find_by(following: other_user)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  # Générer un code de confirmation à 6 chiffres
  def generate_confirmation_code
    self.confirmation_code = rand(100000..999999).to_s
    self.confirmation_code_sent_at = Time.current
    save(validate: false)
  end

  # Vérifier si le code de confirmation est valide (15 minutes max)
  def confirmation_code_valid?(code)
    return false if confirmation_code.blank? || confirmation_code_sent_at.blank?
    return false if confirmation_code != code
    return false if confirmation_code_sent_at < 15.minutes.ago
    true
  end

  # Confirmer avec le code
  def confirm_with_code(code)
    if confirmation_code_valid?(code)
      confirm
      self.confirmation_code = nil
      self.confirmation_code_sent_at = nil
      save(validate: false)
      true
    else
      false
    end
  end

  # Override pour générer le code lors de l'envoi de l'email
  def send_confirmation_instructions
    generate_confirmation_code
    super
  end

  # Plan methods
  def free_plan?
    plan == 'free'
  end

  def builder_plan?
    plan == 'builder'
  end

  def can_create_project?
    return true if builder_plan?
    owned_projects.where(status: %w[draft open in_progress]).count < FREE_PROJECT_LIMIT
  end

  def can_send_message?
    return true if builder_plan?
    reset_monthly_messages_if_needed!
    messages_count_this_month < FREE_MESSAGE_LIMIT
  end

  def increment_message_count!
    reset_monthly_messages_if_needed!
    increment!(:messages_count_this_month)
  end

  def remaining_messages
    return Float::INFINITY if builder_plan?
    reset_monthly_messages_if_needed!
    [ FREE_MESSAGE_LIMIT - messages_count_this_month, 0 ].max
  end

  def remaining_projects
    return Float::INFINITY if builder_plan?
    [ FREE_PROJECT_LIMIT - owned_projects.where(status: %w[draft open in_progress]).count, 0 ].max
  end

  private

  def reset_monthly_messages_if_needed!
    if messages_reset_at.nil? || messages_reset_at < Time.current.beginning_of_month
      update_columns(messages_count_this_month: 0, messages_reset_at: Time.current)
    end
  end

  def normalize_username
    self.username = username.downcase if username.present?
  end

  def level_up_if_needed
    new_level = (experience_points / 100) + 1
    update_column(:level, new_level) if new_level > level && new_level <= 100
  end
end
