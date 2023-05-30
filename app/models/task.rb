class Task < ApplicationRecord
  validates :title, presence: true

  has_many :tasks_categories
  has_many :categories, through: :tasks_categories
end
