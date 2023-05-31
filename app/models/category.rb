class Category < ApplicationRecord
  has_many :tasks_categories, dependent: :destroy
  has_many :tasks, through: :tasks_categories

  validates :title, presence: true
end
