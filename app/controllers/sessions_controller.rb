class SessionsController < ApplicationController
  def new
  end
  
  def create
    email = session_params[:email].downcase
    password = session_params[:password].downcase
    remember_me = session_params[:remember_me]
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      reset_session
      remember_me == '1' ? remember(@user) : forget(@user)
      log_in @user
      flash[:success] = "Welcome back #{@user.name}"
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
  
  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
