module AdminHelper
  include UserHelper

  def pure_users(users)
    new_users = {}
    users.each do |user|
      new_user = {
          username: user['sAMAccountName'],
          fullname: user['displayName'],
          email: user['mail']
      }
      new_users < new_user
    end
    new_users
  end
end
