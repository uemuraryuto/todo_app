class AddColumnTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :end_on, :date, null: false, default: -> { '(CURRENT_DATE)' }, comment: "終了期限"
    add_column :tasks, :status, :integer, null: false, default: 2, comment: "ステータス"
    add_column :tasks, :priority, :integer, null: false, default: 1, comment: "優先順位"
  end
end
