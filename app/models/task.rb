require 'csv'

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

    header_mapping = {
      'ID' => 'id',
      'タイトル' => 'title',
      '本文' => 'body',
      '終了期限' => 'deadline_on',
      'ステータス' => 'status',
      '優先度' => 'priority',
      'カテゴリー' => 'category_titles'
    }

    status_mapping = {
      '未着手' => 'not_started',
      '着手' => 'doing',
      '完了' => 'done'
    }

    priority_mapping = {
      '低' => 'lower',
      '中' => 'middle',
      '高' => 'upper'
    }

    csv = CSV.parse(csv_string, headers: true)
    csv.each.with_index(2) do |row, line_number|
      task = Task.find_or_initialize_by(id: row['ID'])
      transformed_attributes = row.to_hash.transform_keys { |key| header_mapping[key] }.except('category_titles')
      transformed_attributes['status'] = status_mapping[row['ステータス']]
      transformed_attributes['priority'] = priority_mapping[row['優先度']]

      task.attributes = transformed_attributes

      begin
        category_titles = JSON.parse(row['カテゴリー'].split(',').to_json)
        task.categories = Category.where(title: category_titles)
      rescue JSON::ParserError
        error_messages << "#{line_number}行目でエラーが出ています: カテゴリーのJSON解析に失敗しました"
      end

      unless task.save
        error_messages << "#{line_number}行目でエラーが出ています: #{task.errors.full_messages.join(', ')}"
      end
    end

    error_messages
  end
end
