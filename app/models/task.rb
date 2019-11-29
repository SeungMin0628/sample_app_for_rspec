class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :status, presence: true
  enum status: { todo: 0, doing: 1, done: 2 }

  belongs_to :user
end
