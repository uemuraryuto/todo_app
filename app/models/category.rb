class Category < ApplicationRecord
  has_many :tasks_categories
  has_many :tasks, through: :tasks_categories

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    super + ['title']
  end
end
