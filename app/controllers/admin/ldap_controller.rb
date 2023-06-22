module Admin
  class Admin::LdapController < AdminController
    def index
      @users = []
      @users = Ldap::LdapHelper.search_by_username(params[:search]) if params[:search] && !params[:search].empty?
      respond_to do |format|
        format.js
        format.html
        format.json {render json: @users}
      end
    end
  end
end

