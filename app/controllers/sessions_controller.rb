class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Login successfully!"
    else
      flash[:alert] = "Invalid email/password"
      render "new", status: :unprocessable_entity
    end
  end
end
