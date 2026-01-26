class User < ApplicationRecord
  include StatsCacheable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

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

  private

  def normalize_username
    self.username = username.downcase if username.present?
  end

  def level_up_if_needed
    new_level = (experience_points / 100) + 1
    update_column(:level, new_level) if new_level > level && new_level <= 100
  end
end
