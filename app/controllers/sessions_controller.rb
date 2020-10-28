class SessionsController < ApplicationController

  def new; end

  def create
    if user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Login Successful!"
        case user.role
        when 'default'
          redirect_to '/profile'
        when 'merchant_employee'
          redirect_to '/merchant'
        when 'admin'
          redirect_to '/admin'
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

end
