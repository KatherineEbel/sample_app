class SessionsController < ApplicationController
  def new
  end
  
  def create
    email = session_params[:email].downcase
    password = session_params[:password].downcase
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      reset_session
      log_in user
      flash[:success] = "Welcome back #{user.name}"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
  private
  
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
