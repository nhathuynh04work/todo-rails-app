class AddIncompleteTasksCountToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :incomplete_tasks_count, :integer, default: 0, null: false
  end
end
