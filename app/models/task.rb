class Task < ApplicationRecord
  belongs_to :project

  after_commit :update_project_counter

  validates :title, presence: true

  enum :status, { incomplete: 0, complete: 1 }

  private
  def update_project_counter
    project.update_columns(incomplete_tasks_count: project.tasks.where(status: :incomplete).count)
  end
end
