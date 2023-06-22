module SessionsHelper
  def log_in(user)
    session[:user_principal_id] = user.id
  end
  def current_user
    @current_user ||= User.find_by(id: session[:user_principal_id])
  end
  def log_out
    session.delete(:user_principal_id)
    @current_user = nil
  end

  def logined?
    !current_user.nil?
  end
end
