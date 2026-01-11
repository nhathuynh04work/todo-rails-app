class ProjectsController < ApplicationController
  before_action :require_authentication
  before_action :set_project, only: [ :show ]
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

  private
  def set_project
    @project = current_user.projects.find(params[:id])
  end
end
