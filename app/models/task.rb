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

  def self.import(file)
    error_messages = []

    csv_data = File.read(file.path)
    csv_string = csv_data.gsub("\uFEFF", '')

    csv = CSV.parse(csv_string, headers: true)
    csv.each.with_index(2) do |row, line_number|
      task = Task.find_or_initialize_by(id: row['id'].to_i)

      # 属性の設定
      task.title = row['title']
      task.body = row['body']
      task.deadline_on = Date.parse(row['deadline_on'])
      task.status = row['status']
      task.priority = row['priority']

      category_titles = JSON.parse(row['category_titles']) rescue []
      task.categories = Category.where(title: category_titles)

      unless task.save
        error_messages << "#{line_number}行目でエラーが出ています: #{task.errors.full_messages.join(', ')}"
      end
    end

    error_messages
  end
end
