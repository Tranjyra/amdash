class JobsController < ApplicationController
  include ServiceNowApi
  include ActionView::Helpers::TextHelper
  before_action :set_job, only: [:sn_inc_create, :sn_task_create, :sn_inc_delete_link, :show, :destroy, :edit, :update, :done, :accept, :return_to_work, :before_done_send_to_admin]
  before_action :check_edit_job, only: [:edit, :update, :destroy]
  before_action :admin_acces, only: [:accept]

  def index
    @jobs = Job.all.paginate(page: params[:page], per_page: 30).order(created_at: :desc)
  end
  def new
    @job = Job.new
    @store = Store.find(params[:store_code])
    if @store.jobs.any? && @store.jobs.first.status.name == "В работе" && !current_user.admin?
      redirect_back fallback_location: :back, danger: "Вы не можете создать новый выезд, так как предыдущий еще не завершен"
    end
    respond_to do |format|
      format.html
    end
  end
  def create
    #TODO Переработать отправку сообщений, что бы вынести ее из модели
    @job = Job.new(job_params)
    job_action = "create"
    if @job.save
      calculate_latest_job_in_store(@job.store.code)
      #if current_user.admin?
        #notify_user(@job,nil,job_action)
      #else
        #notify_admins(@job,nil,job_action)
      #end
      notify_envolved(@job,nil,job_action)
      redirect_to store_path(@job.store)
    else
      flash[:danger] = "Ошибка сохранения #{@job.errors.full_messages}"
      redirect_back fallback_location: :back
    end
  end

  def show; end

  def edit; end


  def sn_inc_delete_link
      @job.update(:sn_sys_id=>'',:sn_inc=>'')
      redirect_back fallback_location: :back, success: "Отвязка выполнена"
  end


  def sn_inc_create
    store_code = @job.store.code
    #params.require(:job)

    if  @job.sn_inc.blank? || @job.sn_sys_id.blank? || @job.sn_inc=='0' || @job.sn_sys_id=='0'
      #@job.create_in_sn()
      # Job.create_in_sn
      #if @job.accepted_changed? && @job.accepted_change.last && @job.status_id == 1 && !@job.historical
      result=ServiceNowApi::ServiceNowApiHelper.create_sn_ppr(@job.user.username, @job.store.rozn,
                                                              @job.start_date.strftime("%d.%m.%Y"),
                                                              @job.description,
                                                              @job.job_type.name,
                                                              @job.status.name)
      @job.sn_sys_id=result[0]
      @job.sn_inc=result[1]
      @job.update(:sn_sys_id=>result[0],:sn_inc=>result[1])
      #end
    end
  end


  def calculate_latest_job_in_store_all
    #Rails.logger.debug "tesssssst"

    Job.where(islatest: 1).update(:islatest=>0)
    Store.all.each do |storedata|
      result_id=Job.where(store_code: storedata.code).order(start_date: :desc).pluck(:id).first
      if result_id!=nil
      #Rails.logger.debug res.to_s
      #Rails.logger.debug 'storerrrrrrr'
        Job.find(result_id).update(:islatest=>1)
        end
    end

  end


  def calculate_latest_job_in_store(target_store_code)

    result_id=Job.where(store_code: target_store_code).order(start_date: :desc).pluck(:id).first
    if result_id!=nil
      Job.where(store_code:target_store_code,islatest: 1).update(:islatest=>0)
      Job.find(result_id).update(:islatest=>1)
    end

  end


  def sn_task_create
    store_code = @job.store.code
    Rails.logger.debug "[SN RITM Creation FAILED!]:"
    #params.require(:job)

    if  ((!@job.sn_inc.blank? && !@job.sn_sys_id.blank? && @job.sn_inc!='0' && @job.sn_sys_id!='0') && ( @job.sn_task.blank? || @job.sn_task_sys_id.blank? || @job.sn_task=='0' || @job.sn_task_sys_id=='0' ))
      #@job.create_in_sn()
      # Job.create_in_sn
      #if @job.accepted_changed? && @job.accepted_change.last && @job.status_id == 1 && !@job.historical
      result=ServiceNowApi::ServiceNowApiHelper.create_sn_task(@job.user.username, @job.store.rozn,
                                                              @job.start_date.strftime("%d.%m.%Y"),
                                                              @job.description,
                                                              @job.job_type.name,
                                                              @job.status.name)
      @job.sn_task_sys_id=result[0]
      @job.sn_task=result[1]
      @job.update(:sn_task_sys_id=>result[0],:sn_task=>result[1])
      #end
    end
  end


  def update
    if @job.update(job_params)
      calculate_latest_job_in_store(@job.store.code)
      redirect_back fallback_location: :back, success: "Работа обновлена"
    else
      redirect_back fallback_location: :back, danger: "Ошибка сохранения | #{@job.errors.full_messages}"
    end
  end

  def destroy
    store_code = @job.store.code
    if @job.destroy
      calculate_latest_job_in_store(store_code)
      redirect_to store_path(store_code), success: "Работа успешно удалена"
    end
  end

  def return_to_work
    if params[:show_modal]
      respond_to do |format|
        format.js {render partial: "return_to_work_modal"}
      end
    else
      comment = params[:job][:comment]
      job_action = "return_to_work"
      if @job.update(job_params)
        notify_envolved(@job,comment,job_action)
        #notify_user(@job, comment, job_action)
        #notify_admins(@job, comment, job_action)
        ####notify_admins(@job, comment, job_action)
        respond_to do |format|
          format.js
        end
        redirect_back fallback_location: :back, success: "Работа возвращена ответственному инженеру. Статус изменен на #{@job.status.name}"
      else
        redirect_back fallback_location: :back, danger: "Ошибка при возвращении в работу | #{@job.errors.full_messages}"
      end
    end
  end

  def accept
    #TODO Тоже переработать отправку сообщений возможно в коллбэке before_save
    if @job.update(job_accept_params)

      #if @job.job_type.id==2 || @job.job_type.id==4
        sn_inc_create
      #end

      job_action = "accept"
      notify_envolved(@job,nil,job_action)
      #notify_user(@job,nil,job_action)
      #####notify_admins(@job,nil,job_action)
      #notify_admins(@job,nil,job_action)
      redirect_back fallback_location: :back, success: "Проведение работы в этом магазине подтверждено. Статус изменен на #{@job.status.name}"
    else
      redirect_back fallback_location: :back, danger: "Ошибка при подтверждении | #{@job.errors.full_messages}"
    end
  end

  def before_done_send_to_admin
    #TODO Перерабоать отправку сообщений для все модели Job
    if params[:show_modal]
      respond_to do |format|
        format.js {render partial: "before_done_send_to_admin_modal"}
      end
    else
      comment = params[:job][:comment]
      if @job.update(job_done_params)
        job_action = "before_done_send_to_admin"
        #####notify_user(@job,nil,job_action)
        #notify_user(@job,nil,job_action)
        #notify_admins(@job,nil,job_action)
        notify_envolved(@job,comment,job_action)
        redirect_back fallback_location: :back, success: "Работа отправена на рассмотрение администратору. Статус изменен на #{@job.status.name}"
      else
        redirect_back fallback_location: :back, danger: "Ошибка при отправке работы на рассмотрение | #{@job.errors.full_messages}"
      end
    end
  end

  def done
    #TODO Перерабоать отправку сообщений для все модели Job
    if current_user.admin?
        if params[:show_modal]
          respond_to do |format|
            format.js {render partial: "done_modal"}
          end
        else
            comment = params[:job][:comment]
            if @job.update(job_done_params)
              job_action = "done"
              notify_envolved(@job,comment,job_action)
              #notify_user(@job,comment,job_action)
              #notify_admins(@job,comment,job_action)
              #########notify_admins(@job,nil,job_action)
              redirect_back fallback_location: :back, success: "Работа успешно одобрена. Статус изменен на #{@job.status.name}"
            else
              redirect_back fallback_location: :back, danger: "Ошибка при одобрении работы | #{@job.errors.full_messages}"
            end
        end
    else
      redirect_back fallback_location: :back, danger: "У вас недостаточно прав для совершения этого действия"
    end

  end


  private

  def job_params
    params.require(:job).permit(:start_date, :end_date, :store_code, :user_id, :status_id, :job_type_id, :accepted, :historical, :description)
  end
  #TODO Убрать лишние установки параметры в пользу переноса логики в модель
  def job_done_params
    params.require(:job).permit(:status_id)
  end

  def job_accept_params
    params.require(:job).permit(:status_id, :accepted)
  end

  def set_job
    begin
      @job = Job.find(params[:id])
      @store = @job.store
    rescue
      redirect_to root_path, danger: "Нет работы с таким id"
    end

  end
  #TODO избавиться от методов отправки в контроллере после переноса их в модель

  def format_comment(comment=nil)
    if comment!=nil && comment!=''
      comment=simple_format(comment,{},wrapper_tag: "span")
    end
    comment
  end

  def notify_admins(job, comment=nil, job_action="nil")
    return
    comment=format_comment(comment)

    if @job.store.pure_name!='Тестовый магазин'
      User.admins_only.each do |user|
        Event.create!(user_id: user.id, from_user_id: job.user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
        JobNotifyMailer.with(job: job, email: user.email,comment:comment,job_action:job_action,current_user:current_user).notify_admin.deliver_later
      end
    else
      Event.create!(user_id: 19, from_user_id: job.user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
      JobNotifyMailer.with(job: job, email: 'zazin@gloria-jeans.ru',comment:comment,job_action:job_action,current_user:current_user).notify_admin.deliver_later
    end
  end

  def notify_user(job, comment=nil, job_action="nil")
    return
    comment=format_comment(comment)

    if @job.store.pure_name!='Тестовый магазин'
      Event.create!(user_id: job.user.id, from_user_id: current_user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
      JobNotifyMailer.with(job: job, who: current_user,comment:comment,job_action:job_action,current_user:current_user).notify_user.deliver_later
    else
      Event.create!(user_id: job.user.id, from_user_id: current_user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
      JobNotifyMailer.with(job: job, who: current_user,comment:comment,job_action:job_action,current_user:current_user).notify_user.deliver_later
    end
  end

  def notify_envolved(job, comment=nil, job_action="nil")

    comment=format_comment(comment)

    JobNotifyMailer.with(job: job, who: current_user,comment:comment,job_action:job_action,current_user:current_user).notify_user.deliver_later

    if @job.store.pure_name!='Тестовый магазин'
      User.admins_only.each do |user|
        Event.create!(user_id: user.id, from_user_id: job.user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
        #JobNotifyMailer.with(job: job, email: user.email,comment:comment,job_action:job_action,current_user:current_user).notify_admin.deliver_later
        JobNotifyMailer.with(job: job, email: 'zazin@gloria-jeans.ru',comment:comment,job_action:job_action,current_user:current_user).notify_admin.deliver_later
         return
      end

      #if !current_user.admin?
      if (current_user.admin? && job.user.id!=current_user.id)||(!current_user.admin?)
        Event.create!(user_id: job.user.id, from_user_id: current_user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
        #JobNotifyMailer.with(job: job, who: current_user,comment:comment,job_action:job_action,current_user:current_user).notify_user.deliver_later
        ##JobNotifyMailer.with(job: job, email: 'zazin@gloria-jeans.ru',comment:"Отправлено уведомление "+job.user.email+" current_user="+current_user.id.to_s,job_action:job_action,current_user:current_user).notify_admin.deliver_later
      end


    else
      Event.create!(user_id: 19, from_user_id: job.user.id, serialized_subject: {class_name: job.class.to_s, id: job.id}, readed: false, event_type: 1, comment: comment)
       #JobNotifyMailer.with(job: job, email: 'zazin@gloria-jeans.ru',comment:comment,job_action:job_action,current_user:current_user).notify_admin.deliver_later
      ##JobNotifyMailer.with(job: job, who: job.user,comment:comment,job_action:job_action,current_user:current_user).notify_user.deliver_later
      #JobNotifyMailer.with(job: job, email: 'zazin@gloria-jeans.ru',comment:"Отправлено уведомление "+job.user.email+" current_user="+current_user.id.to_s,job_action:job_action,current_user:current_user).notify_admin.deliver_later
    end

  end

  #simple_format(@comment,{},wrapper_tag: "span")



  #TODO Поискать способ отправить это в модель, хотя это поидее должно быть тут наверное
  def check_edit_job
    if @job.accepted && !current_user.admin? && @job.status_id != 1
      redirect_back fallback_location: :back, danger: "Вы не можете изменить подтвержденную работу"
    end
  end

  def admin_acces
    if !current_user.admin?
      redirect_back fallback_location: :back, danger: "Только администратор может сделать #{action_name}"
    end
  end
end
