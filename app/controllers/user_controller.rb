class UserController < ApplicationController
  before_action :user_params, only: [:create, :update]
  before_action :set_user, only: [:show, :edit, :update]
  def index
    @users = User.all
  end

  def show; end



  private

  def set_user
    @user = User.find(params[:id])
  end
end
