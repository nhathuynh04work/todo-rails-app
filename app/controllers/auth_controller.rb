class AuthController < ApplicationController
  def signup
    @user = User.new
  end

  def register_user
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "Account created!"
    else
      flash.now[:alert] = "Invalid input"
      render :signup, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.expect(user: [ :first_name,
                          :last_name,
                          :email,
                          :password,
                          :password_confirmation ])
  end
end
