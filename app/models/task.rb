class Task < ApplicationRecord
  has_many :tasks_categories
  has_many :categories, through: :tasks_categories

  validates :title, presence: true
end
