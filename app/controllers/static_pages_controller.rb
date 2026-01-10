class StaticPagesController < ApplicationController
  def home
    redirect_to dashboard_url if current_user
  end
end
