class SessionsController < ApplicationController
  def new
  end
  
  def create
    email = session_params[:email].downcase
    password = session_params[:password].downcase
    remember_me = session_params[:remember_me]
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        remember_me == '1' ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
  
  private
  
  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
