class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)

    user.save
    session[:user_id] = user.id
    flash[:success] = 'You are now registered and logged in'
    redirect_to '/profile'
  end

  def show
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :address,
                                 :city,
                                 :state,
                                 :zip,
                                 :email,
                                 :password)
  end
end
