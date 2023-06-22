module Admin
  class Admin::UsersController < AdminController
    before_action :admin?, except: [:index]
    before_action :set_user, only: [:update, :edit]
    def index
      @users = User.all
      @users = @users.search_by_name(params[:search]) if params[:search] && !params[:search].empty?
      respond_to do |format|
        format.js
        format.html
      end
    end
    def new
      @user = User.new
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        respond_to do |format|
          format.js
          format.html
        end
      end
    end

    def edit; end

    def update
      if @user.update(user_params)
        respond_to do |format|
          format.js
          format.html
        end
      end
    end

    private
    def user_params
      params.require(:user).permit(:username, :email, :fullname, :role_id, :supervisor, :password, :flocal)
    end
    def set_user
      @user = User.find(params[:id])
    end
  end
end

