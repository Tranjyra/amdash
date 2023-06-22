module RegistratorsHelper
  def select_registrators
    select = []
    Staff.all.where(staff_type: 2).each do |staff|
      select << [staff.name, staff.id]
    end
    select
  end
end
