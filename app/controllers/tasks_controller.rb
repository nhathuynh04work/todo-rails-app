class TasksController < ApplicationController
  before_action :require_authentication
  before_action :set_project

  def new
    render partial: "tasks/task_create_ui", locals: { project: @project, open: true }
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Missing title for task"

          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("new_task_ui", partial: "tasks/task_create_ui", locals: { project: @project, open: true })
          ]
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def task_params
    params.expect(task: [ :title ])
  end
end
