class StoresController < ApplicationController
  before_action :set_store, only: [:show]
  before_action :query_params, only: [:index]
  def index
    @stores = Store.all.jobs_new_to_old

    @stores = @stores.by_job_date(params[:date_start], params[:date_end]) if params[:date_start] || params[:date_end]
    #@stores = @stores.by_user_name(params[:user_name]) if params[:user_name] && !params[:user_name].empty?
    @stores = @stores.by_user_id(params[:user_id]) if params[:user_id] && !params[:user_id].empty?
    @stores = @stores.by_job_stat(params[:job_status_id]) if params[:job_status_id] && params[:job_status_id] != "0"
    @stores = @stores.by_job_type(params[:job_type_id]) if params[:job_type_id] && params[:job_type_id] != "0"


    @stores = @stores.by_name(params[:name]) if params[:name] && !params[:name].empty?
    @stores = @stores.by_region(params[:region]) if params[:region] && !params[:region].empty?
    @stores = @stores.by_status(params[:s_stat]) if params[:s_stat] && !params[:s_stat].empty?

    if !params[:s_stat] || params[:s_stat].empty?
      #@stores = @stores.where.not(s_stat: "Закрыт")
    end
    # Hide Тестовый магазин from INDEX page
    # Show it only to user with id 19
    if current_user.id!=19
      @stores = @stores.where.not(name: "м-н Тестовый магазин")
    end

    @stores_filter_status=''
    @stores_filter_status= params[:s_stat] if params[:s_stat] && !params[:s_stat].empty?

    @pagy, @stores = pagy(@stores)
  end

  def main
     if current_user.admin?
       index
       render( 'index')
     else
       user
       render('user')
     end
  end

  def user
    @userid=params[:userid]

    @stores = Store.all.jobs_new_to_old
    @stores = @stores.by_user_id(current_user.id)

    @cnt=@stores.count
    @pagy, @stores = pagy(@stores)
  end

  def show; end

  private

  def set_store
    @store = Store.find(params[:code])
  end
  def query_params
    params.permit(:region, :name, :s_stat, :user_name, :user_id, :date_start, :date_end, :code, :job_status_id, :job_type_id)
  end
end
