class RenameEndOnColumnToTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :end_on, :deadline_on
  end
end
