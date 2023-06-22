module Admin::StaffHelper
  def select_zones
    select = []
    Staff.all.where(staff_type: 1).each do |staff|
      select << [staff.name, staff.id]
    end
    select
  end
end
