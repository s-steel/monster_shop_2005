class UsersController < ApplicationController
  def new; end

  def create
    if params[:user][:password] == params[:user][:confirm_password]
      user = User.new(user_params)
      begin
        user.save!
        session[:user_id] = user.id
        flash[:success] = 'You are now registered and logged in'
        redirect_to '/profile'
      rescue ActiveRecord::RecordInvalid => e
        create_error_response(e)
        render :new
      end
    else
      flash[:error] = "Passwords must match."
      redirect_to '/register'
    end
  end

  def show
    if current_user.nil?
      render file: "/public/404"
    else
      @user = current_user
    end
  end

  def orders
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    begin
    @user.update!(
      name: params[:user][:name],
      address: params[:user][:address],
      city: params[:user][:city],
      state: params[:user][:state],
      zip: params[:user][:zip],
      email: params[:user][:email]
    )
    flash[:success] = "Profile updated successfully!"
    redirect_to '/profile'
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      redirect_to profile_edit_path
    end
  end

  def change_password
    @user = current_user
  end

  def update_password
    if params[:password] != params[:confirm_password]
      flash.now[:error] = "Passwords do not match. Try again."
      render :change_password
    else
      @user = current_user
      @user.update!(
        password: params[:password],
        password_confirmation: params[:confirm_password]
        )
      flash[:success] = "Password updated successfully!"
      redirect_to '/profile'
    end
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
      flash[:error] = error.message.delete_prefix('Validation failed: ')
  end
end
