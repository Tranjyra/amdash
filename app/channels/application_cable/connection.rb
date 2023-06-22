module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      self.current_user = find_verifed_user
    end

    private
    def find_verifed_user
      if (verifed_user = User.find_by(id: request.session[:user_principal_id]))
        verifed_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
