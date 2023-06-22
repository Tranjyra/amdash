class Store < ApplicationRecord
  self.primary_key = :code
  default_scope { where("name NOT LIKE '%Ecomm%' AND name NOT LIKE '%TMALL%' AND baseidd IS NOT null AND (baseidd*1) > 1 ") }

  scope :by_name, ->(name) { where("name LIKE :name "+  # Произвольное имя магазина
                                       "or (baseidd*1) = :namefixed "+   #Точное совпадение по Номеру ROZN
                                       "or CONCAT('rozn',(baseidd*1)) LIKE :namefixed " + #Точное совпадение по roznНОМЕР
                                       "or (baseidd*1) = CONCAT(6,LPAD(:namefixed,GREATEST(LENGTH(:namefixed), 2),'0')) " + #Точное совпадение по Номеру ROZN, если он в формате 6xx
                                       "or CONCAT('rozn',(baseidd*1)) = CONCAT(6,LPAD(:namefixed,GREATEST(LENGTH(:namefixed), 2),'0')) ", #Точное совпадение по roznНОМЕР, если он в формате 6xx
                                        :name=>"%#{name}%",:namefixed=>"#{name}") }
  #scope :by_name, ->(name) { where("name LIKE (?) or (baseidd*1) = (?) or 'rozn'+(baseidd*1) LIKE (?)  ", "%#{name}%", "#{name}","#{name}") }

  scope :name_ordered, -> {order(name: :asc)}
  scope :by_region, ->(region) { where region: region }
  scope :by_status, ->(s_stat) { where s_stat: s_stat }
=begin
    scope :jobs_new_to_old, -> { joins("left join (
                                select * from jobs as j where start_date =
                                (select max(start_date) from jobs where store_code = j.store_code LIMIT 1))
                                as jobss on jobss.store_code = stores.code").where('jobss.user_id=13').order('FIELD(jobss.status_id,4,3,1,2,5) desc','jobss.start_date desc') }

  #order('jobss.status_id desc','jobss.start_date desc')
=end
  scope :jobs_new_to_old, #-> { joins("left join (
                          #      select * from jobs as j where start_date =
                          #      (select max(start_date) from jobs where store_code = j.store_code LIMIT 1))
                          #       as jobss on jobss.store_code = stores.code").order('FIELD(jobss.status_id,4,3,1,2,5) desc','jobss.start_date desc') }
        -> { joins("left join jobs on jobs.store_code = stores.code and jobs.islatest=1").order('FIELD(jobs.status_id,4,3,1,2,5) desc','jobs.start_date desc') }
=begin
        -> { joins("left join (
                                select * from jobs as j where start_date =
                                (select start_date from jobs where store_code = j.store_code order by start_date desc LIMIT 1 ))
                                 as jobss on jobss.store_code = stores.code").order('FIELD(jobss.status_id,4,3,1,2,5) desc','jobss.start_date desc') }
=end

  scope :by_job_date, ->(date_start = nil, date_end = nil) {
    date_start ||= Job.last.start_date
    date_end ||= Time.zone.now
    joins(:jobs).where(jobs: {start_date: date_start..date_end })
  }
  scope :by_user_name, ->(user_name) { joins(:jobs).where(jobs: { user_id: User.find_by(username: user_name.downcase).id }) }
  scope :by_user_id, ->(user_id) { where(jobs: { user_id: user_id }) }
  scope :by_job_stat, ->(job_stat_id) { joins(:jobs).where(jobs: {status_id: job_stat_id}) }
  scope :by_job_type, ->(job_type_id) { joins(:jobs).where(jobs: {job_type_id: job_type_id}) }
  has_many :jobs, foreign_key: :store_code

  def rozn
    self.email.split('@').first if self.email
  end
  def pure_name
    name.sub("м-н", "").strip
  end
end
