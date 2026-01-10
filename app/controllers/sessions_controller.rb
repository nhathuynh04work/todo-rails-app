class SessionsController < ApplicationController
  before_action :require_logged_out, only: [ :new, :create ]
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.authenticate_by(email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_url, notice: "Login successfully!"
    else
      flash[:alert] = "Invalid email/password"
      render "new", status: :unprocessable_entity
    end
  end

  private
  def require_logged_out
    if current_user
      redirect_to dashboard_url
    end
  end
end
