class TasksController < ApplicationController
  before_action :require_authentication
  before_action :set_project, only: %w[ new create ]
  before_action :set_task, only: %w[ toggle destroy ]

  def new
    render partial: "tasks/task_create_ui", locals: { project: @project, open: true }
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("tasks_list", partial: "tasks/task", locals: { task: @task }),
            turbo_stream.replace("new_task_ui", partial: "tasks/task_create_ui", locals: { project: @project, open: true }),
            turbo_stream.remove("no_tasks_msg"),
            update_sidebar_count_stream
          ]
        end
        format.html { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Missing title for task"

          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("new_task_ui", partial: "tasks/task_create_ui", locals: { project: @project, open: true }),
            update_sidebar_count_stream
          ]
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    new_status = @task.complete? ? :incomplete : :complete

    if @task.update(status: new_status)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task }),
            update_sidebar_count_stream
          ]
        end

        format.html { redirect_to project_path(@task.project) }
      end
    else
      redirect_to project_path(@task.project), alert: "Could not update task."
    end
  end

  def destroy
    if @task.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@task),
            update_sidebar_count_stream
          ]
        end

        format.html { redirect_to project_path(@task.project) }
      end
    else
      redirect_to project_path(@task.project), alert: "Could not delete task."
    end
  end

  private
  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
    @project = @task.project
  end

  def task_params
    params.expect(task: [ :title ])
  end

  def update_sidebar_count_stream
    turbo_stream.replace(
      @project,
      partial: "projects/project",
      locals: { project: @project.reload }
    )
  end
end
