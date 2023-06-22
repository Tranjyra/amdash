class User < ApplicationRecord
  private :id=
  default_scope { includes(:jobs, :user_role, :events) }
  scope :admins_only, -> { where(role_id: 1) }
  scope :exclude_user, -> (user_id) { where.not(id: user_id) }
  scope :search_by_name, -> (name) {where "fullname like (?)", "%#{name}%"}
  scope :search_by_id, -> (user_id) {where(id: user_id)}
  scope :supervisers, -> {where supervisor: true}
  belongs_to :user_role, foreign_key: :role_id
  has_many :jobs
  has_many :user_default_queries
  has_many :events
  has_many :infos
  has_many :subjobs


  def firstname
    fullname.split.first
  end

  def name_short
    orig_name=name
    arr=orig_name.split(' ')

    if arr.size==3
      name_short=arr[0]+' '+arr[1].slice(0,1).capitalize+'. '+arr[2].slice(0,1).capitalize+'. '
    else
      name_short=orig_name
    end

  end

  def name
    name_reg = %r"\((.*?)\)"
    match = self.fullname.match name_reg
    if match
      name = match.captures.first
    else
      name = self.fullname.split.first
    end
  end

  def admin?
    case self.user_role.role
    when 'Admin'
      true
    when 'User'
      false
    else
      false
    end
  end
end
