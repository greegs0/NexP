class Team < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, uniqueness: { scope: :project_id }
  validates :status, inclusion: { in: %w[pending accepted rejected] }

  # Scopes
  scope :accepted, -> { where(status: 'accepted') }
  scope :pending, -> { where(status: 'pending') }
  scope :rejected, -> { where(status: 'rejected') }
end
