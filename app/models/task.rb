class Task < ApplicationRecord
  has_many :tasks_categories, dependent: :destroy
  has_many :categories, through: :tasks_categories

  enum :status, { done: 0, doing: 1, not_started: 2 }
  enum :priority, { upper: 0, middle: 1, lower: 2 }

  validates :title, presence: true

  validate :check_deadline_past

  def check_deadline_past
    if deadline_on < Date.today
      errors.add(:deadline_on, 'が本日以前の日付なので登録できません')
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title body deadline_on priority]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categories]
  end
end
