class AddUserIdToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :user, null: false, foreign_key: true, index: false

    add_index :tasks, [ :user_id, :updated_at ], order: { updated_at: :desc }
  end
end
