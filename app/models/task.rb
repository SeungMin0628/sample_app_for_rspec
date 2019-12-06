class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :status, presence: true
  enum status: %i[todo doing done]

  belongs_to :user
end
