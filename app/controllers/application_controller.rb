# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :authentificate
  add_flash_types :danger, :success

  private

  def authentificate
    unless logined?
      session[:return_path] = request.url
      redirect_to login_path
    end
  end
  def render_404
    render :file => "#{Rails.root}/public/404.html", status: 404
  end
end