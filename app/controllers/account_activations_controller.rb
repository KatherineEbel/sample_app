class AccountActivationsController < ApplicationController
  # http://localhost:3000/account_activations/0Cc6op4E0PQgM4Nfdb37rw/edit?email=kathyebel%40me.com
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
