class SessionsController < ApplicationController
  skip_before_action :authentificate, only: [:new, :create]

  def new
  end

  def create
    username = params[:session][:username].downcase
    password = params[:session][:password]
    user = User.find_by(username: username)
    if user

      if user.flocal
        if User.find_by(username: username,password:password)
          log_in(user)
          flash[:success] = "Вход выполнен!"
          redirect_to session[:return_path] ? session[:return_path] : root_path
        else
          flash[:danger] = 'Invalid user name or password'
          render 'new'
        end
      else

        flash[:danger] = 'LDAP авторизация не настроена'
        render 'new'
        return

        #TODO: Указать данные авторизации LDAP

        if Ldap::LdapHelper.login_as(username, password)
          log_in(user)
          flash[:success] = "Succefully logon via LDAP"
          redirect_to session[:return_path] ? session[:return_path] : root_path
        else
          flash[:danger] = 'Invalid user name or password'
          render 'new'
        end
      end


    else
      flash[:danger] = 'Пользователь не найден или недостаточно прав на авторизацию под указанной учетной записью.'
      render 'new'
    end
  end

  def delete
    log_out
    redirect_to root_path
  end
end
