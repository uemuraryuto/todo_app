class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, comment: "タイトル"
      t.text :body,  comment: "本文"
      t.timestamps
    end
  end
end
