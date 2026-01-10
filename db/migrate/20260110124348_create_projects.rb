class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end

    add_reference :tasks, :project, null: false, foreign_key: true
    remove_reference :tasks, :user, index: true, foreign_key: true
  end
end
