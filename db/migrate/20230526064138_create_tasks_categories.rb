class CreateTasksCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks_categories do |t|
      t.references  :task,  index: true, foreign_key: true
      t.references  :category, index: true, foreign_key: true
      t.timestamps
    end
  end
end
