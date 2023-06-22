module UserHelper
  def user_exist?(username)
    User.find_by_username(username.downcase)
  end

  def user_select
    select = []
    User.all.each do |user|
      select << [user.fullname, user.id]
    end
    select
  end




end
