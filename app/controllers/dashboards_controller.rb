class DashboardsController < ApplicationController
  before_action :require_authentication
  layout "dashboard"

  def show
  end
end
