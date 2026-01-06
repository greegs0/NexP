class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :project

  validates :content, presence: true
end
