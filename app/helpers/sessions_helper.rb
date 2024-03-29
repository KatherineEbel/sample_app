module SessionsHelper
  # log_in logs in given user
  def log_in(user)
    session[:user_id]       = user.id
    session[:session_token] = user.session_token
  end
  
  # log_out logs out current user
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  
  # forget forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # remember generates a remember token for a user and adds it to a cookie with the user's id
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token]    = user.remember_token
  end
  
  # current_user returns the current logged-in user if any
  def current_user
    if (user_id = session[:user_id])
      user          = User.find_by(id: user_id)
      @current_user ||= user if session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
    user = User.find_by(id: user_id)
    if user && user.authenticated?(:remember, cookies[:remember_token])
      log_in user
      @current_user = user
    end
  end
end

def current_user?(user)
  user && user == current_user
end

# returns true if current user is not nil
def logged_in?
  !current_user.nil?
end

# store_location stores the URL trying to be accessed
def store_location
  session[:forwarding_url] = request.original_url if request.get?
end
end
