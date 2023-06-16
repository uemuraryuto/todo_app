class Category < ApplicationRecord
  has_many :tasks_categories, dependent: :destroy
  has_many :tasks, through: :tasks_categories

  validates :title, presence: true

  scope :categories_search, -> (search) { search.present? ? where('title LIKE ?', "%#{search}%") : all }

  def self.ransackable_attributes(auth_object = nil)
    super + ['title']
  end
end
