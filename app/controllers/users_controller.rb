class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)
    begin
      user.save!
      session[:user_id] = user.id
      flash[:success] = 'You are now registered and logged in'
      redirect_to '/profile'
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
    end
  end

  def show
    if current_user.nil?
      render file: "/public/404"
    else
      @user = current_user
    end
  end

  def edit
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

  def create_error_response(error)
    case error.message
    when "Validation failed: Name can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank"
      flash[:error] = 'Please enter data in all required fields'
      redirect_to '/register'
    when 'Validation failed: Email has already been taken'
      flash[:error] = 'This email is already registered. Please use a new email.'
      redirect_to '/register'
    end
  end
end
