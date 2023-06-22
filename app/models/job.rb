class Job < ApplicationRecord
  include ServiceNowApi
  default_scope {includes(:user).order(start_date: :desc)}
  scope :with_accepted, ->(accepted) {where(accepted: accepted)}
  scope :not_regular, ->{ joins(:job_type).where.not(job_types: {name: "Профилактика"}).where.not(job_types: {name: "Выезд"})}
  belongs_to :store, foreign_key: :store_code
  belongs_to :job_type
  belongs_to :user
  belongs_to :status
  has_one :job_info
  has_many :patch_panels
  has_many :photos
  has_many :registrators

  validates :start_date, presence: {message: "Дата начала не может быть пустой"}
  validate :duplicate_one_time_job?, on: :create
  validate :check_past
  validate :check_duplicate
  validate :check_required_photos
  validate :check_required_fields
  after_save :send_supervised_photos, if: :on_supervise
  #before_save :create_in_sn

  def self.to_csv
    atrributes = %w{Тип Статус Магазин Инженер Дата_начала Дата_окончания}
    CSV.generate(headers: true, col_sep: ";", encoding: "cp1251") do |csv|
      csv << atrributes
      all.each do |job|
        csv << [job.job_type.name, job.status.name, job.store.name, job.user.fullname, (job.start_date ? job.start_date.strftime("%d.%m.%Y") : ""), (job.end_date ? job.end_date.strftime("%d.%m.%Y") : "")]
      end
    end
  end
  def comment
    nil
  end

  private


  def create_in_sn
    if self.accepted_changed? && self.accepted_change.last && self.status_id == 1 && !self.historical
      ServiceNowApi::ServiceNowApiHelper.create_sn_ppr(self.user.username, self.store.rozn,
                                                       self.start_date.strftime("%d.%m.%Y"),
                                                       self.comment,
                                                       self.job_type.name,
                                                       self.status.name)
    end
  end


  def duplicate_one_time_job?
    if self.store.jobs.not_regular.any?
      if self.store.jobs.not_regular.first.job_type.name == self.job_type.name
        errors.add(:Тип_работы, "Нельзя создать #{job_type.name} поверх #{self.store.jobs.not_regular.first.job_type.name}")
      end
    end
  end

  def check_required_fields
    if self.description.to_s.length<2 && self.job_type.id==4
      errors.add(:Описание_работы,"Оставьте описание Выезда");
    end
  end

  def check_past
    if !self.historical && self.start_date_changed?
      if self.start_date < Date.today
        errors.add(:Дата_начала, "Вы не можете создать работу в прошлом.")
      end
    end
  end

  def check_duplicate
    if self.store.jobs.any? && self.start_date_changed?
      if self.store.jobs.where(start_date: self.start_date, user_id: self.user_id).count > 0
        errors.add(:Дата_начала, "Вы не можете создать две работы в одном магазине в один день.")
      end
    end
  end
  def check_required_photos
    if status.id == 5
      countphotos=0
      phts = photos.includes(:eq)
      Staff.required.each do |req_staff|
        #TODO: ниже временный код. Нужно сделать таблицу соотношения обязательного стафа и работ
        next if self.job_type.id == 4 #если это выезд, то пропускаем проверки
        countphotos += 1

        if self.job_type.id == 3
          next if req_staff.id != 31 && req_staff.id != 41
        else
          next if req_staff.id == 41  # если любой дугой тип работы - то не проверяем, есть ли заявдение на расторжение
        end

        unless phts.exists?(eq_id: req_staff.id)
          errors.add("Обязательное_фото_не_добавлено ->", req_staff.name)
        end
      end


    end
  end


  def send_supervised_photos
    s_photos = photos.includes(:eq).where(staffs: {supervised: true}).where('photos.checked IS NULL OR photos.checked != TRUE')
    photos_list = []
    s_photos.each do |photo|
      puts "*************************"
      puts "*************************"
      puts photo
      puts "*************************"
      puts "*************************"
      puts "*************************"
      photos_list << photo
    end
    SuperviseMailer.with(photos: photos_list, store: store.name).supervised_photo.deliver_later
  end
  def on_supervise
    status.id == 5
  end
end
