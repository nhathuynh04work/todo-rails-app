class ProjectsController < ApplicationController
  before_action :require_authentication
  def new
    @project = Project.new
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
end
