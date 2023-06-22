module StoresHelper
  def regions
    regions = Store.select(:region).distinct
  end

  def status
    status = Store.select(:s_stat).distinct
  end

  def status_select
    select = []
    status.each do |stat|
      select << stat.s_stat
    end
    select << ["Статус", ""]
  end
  def region_select
    select = []
    regions.each do |region|
      select << region.region
    end
    select << ["Регион", ""]
  end

  def job_select
    select = []
    select << ["Ответственный", ""]

    User.all.each do |user|
      select << [user.fullname, user.id]
    end

    #Job.select(:user_id).distinct.each do |job|
      #select << [job.user.fullname, job.user.username]
    #end
    #select << ["Инженер", ""]


    select

  end
end
