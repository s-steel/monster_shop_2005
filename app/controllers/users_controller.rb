class UsersController < ApplicationController

  def new
  end

  def create
    user = User.new(user_params)

    user.save
    redirect_to '/profile'
  end


  private

  def user_params
    params.require(:user).permit(:name,
                  :address,
                  :city,
                  :state,
                  :zip,
                  :email,
                  :password
                  )
  end 
end
