class SessionsController < ApplicationController

  def new
    flash[:success] = 'You are already logged in!' if current_user

    if current_merchant?
      redirect_to "/merchant"
    elsif current_admin?
      redirect_to "/admin"
    elsif current_user
      redirect_to "/profile"
    end
  end

  def create
    if user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Login Successful!"
        case user.role
        when 'merchant_employee'
          redirect_to '/merchant'
        when 'admin'
          redirect_to '/admin'
        when 'default'
          redirect_to '/profile'
        end
      else
        flash[:error] = 'Invalid email or password, please try again.'
        redirect_to '/login'
      end
    else
      flash[:error] = 'Invalid email or password, please try again.'
      redirect_to '/login'
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = 'You are logged out!'

    redirect_to '/'
  end

end
