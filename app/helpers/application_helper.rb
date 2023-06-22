module ApplicationHelper
  include Pagy::Frontend
  def human_date(date,rusflag=false)
    if date
      d = Date.strptime(date.to_s, '%Y-%m-%d')
      #time = d.strftime('%d.%m.%Y')
      if d.year ==  Date.today.year
        if rusflag
          time = Russian::strftime(d,'%d %B')
        else
          time = d.strftime('%d/%m')
        end
      else
        time = d.strftime('%d.%m.%Y')
      end
    else
      time = "Не указана дата"
    end
  end

  def job_date_str(job)
     if job.start_date.year==Date.today.year && job.end_date && job.end_date!=job.start_date && job.end_date>job.start_date
        if job.end_date.month==job.start_date.month
            "%02d" % job.start_date.day+"-"+human_date(job.end_date, true)
        else
           'с '+human_date(job.start_date, true) + ' по '+human_date(job.end_date, true)
        end
    else
      ' от '+human_date(job.start_date)
    end
  end

  def class_to_s(klass)
    klass.class.to_s.downcase
  end
end
