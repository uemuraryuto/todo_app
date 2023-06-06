class Task < ApplicationRecord
  has_many :tasks_categories
  has_many :categories, through: :tasks_categories

  enum :status, { done: 0, doing: 1, not_started: 2 }
  enum :priority, { upper: 0, middle: 1, lower: 2 }

  validates :title, presence: true

  validate :deadline_check

  def deadline_check
    if deadline_on.present? && deadline_on < Date.today
      errors.add(:deadline_on, 'が本日以前の日付なので登録できません')
    end
  end
end
