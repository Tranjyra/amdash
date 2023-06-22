module JobsHelper
  def last_job(store)
    last_job = store.jobs.order(created_at: :desc).first
  end

  def first_name(fullname)
    name = fullname.split().first
  end

  def select_options_job_type
    job_types = JobType.all
    select = []
    job_types.each do |job_type|
      select << [job_type.name, job_type.id]
    end
    select << ["Тип работы", 0]
  end

  def select_options_job_status
    select = []
    Status.all.each do |status|
      select << [status.name, status.id]
    end
    select << ["Статус работы", 0]
  end

  def type_color(job_type)
    case job_type
    when "Открытие"
      color = "success"
    when "Закрытие"
      color = "danger"
    when "Профилактика"
      color = "primary"
    when "Выезд"
      color = "yellow1"
    end
  end
end
