class SessionsController < ApplicationController
  before_action :require_logged_out, only: [ :new, :create ]
  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_url, notice: "Login successfully!"
    else
      flash.now[:alert] = "Invalid email/password"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_url, notice: "Logged out"
  end

  private
  def require_logged_out
    if current_user
      redirect_to dashboard_url
    end
  end
end
