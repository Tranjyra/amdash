class JobNotifyMailer < ApplicationMailer
  include ApplicationHelper
  add_template_helper(ApplicationHelper)

  include SessionsHelper

  def notify_admin
    @job = params[:job]
    @email = params[:email]
    @comment =params[:comment]
    @job_action =params[:job_action]
    @current_user=params[:current_user]
    @url = job_url(@job)
    if @job.store.pure_name!='Тестовый магазин'
    make_bootstrap_mail(to: @email, subject: "#{subject_prepend}(тест2) #{@job.user.name}, работа в м-не #{@job.store.pure_name}")
    else
      make_bootstrap_mail(to: "zazin@gloria-jeans.ru", subject: "#{subject_prepend}(тест) #{@job.user.name}, работа в м-не #{@job.store.pure_name}")
    end
  end

  def notify_user
    @job = params[:job]
    @who = params[:who]
    @comment =params[:comment]
    @job_action =params[:job_action]
    @current_user=params[:current_user]
    @url = job_url(@job)
    if @job.store.pure_name!='Тестовый магазин'
    make_bootstrap_mail(to: @job.user.email, subject: "#{subject_prepend} #{@job.job_type.name} от #{human_date(@job.start_date)}, #{@job.store.name}")
    else
      make_bootstrap_mail(to: "zazin@gloria-jeans.ru", subject: "#{subject_prepend}(тест) #{@job.job_type.name} от #{human_date(@job.start_date)}, #{@job.store.name}")
      end
  end
end
