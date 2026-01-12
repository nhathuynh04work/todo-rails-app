class ProjectsController < ApplicationController
  before_action :require_authentication
  before_action :set_project, only: %w[ show destroy ]
  layout "dashboard"

  def new
    @project = Project.new

    if turbo_frame_request?
      render layout: false
    end
  end

  def create
    @project = current_user.projects.new(params.expect(project: [ :title ]))

    if @project.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to dashboard_url }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    prev_project = current_user.projects.order(:title).where("title < ?", @project.title).last
    next_project = current_user.projects.order(:title).where("title > ?", @project.title).first
    @adjacent_project = prev_project || next_project

    if @project.destroy
      respond_to do |format|
        format.turbo_stream do
          if request.referer == project_url(@project)
            redirect_to(@adjacent_project ? project_path(@adjacent_project) : dashboard_path, status: :see_other)
          else
            render turbo_stream: turbo_stream.remove(@project)
          end
        end

        format.html do
          if @adjacent_project
            redirect_to project_path(@adjacent_project)
          else
            redirect_to dashboard_path
          end
        end
      end
    else
      redirect_to project_path(@project), alert: "Failed to delete project"
    end
  end

  private
  def set_project
    @project = current_user.projects.find(params[:id])
  end
end
