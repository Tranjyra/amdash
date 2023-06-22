# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Status.all.any?
  status = Status.create!([{ name: "Запланировано" }, { name: "В работе" }, { name: "Завершено" }, { name: "Отменено" }, {name: "На рассмотрении"}])
end

unless JobType.all.any?
  job_type = JobType.create!([{name: "Открытие"}, {name: "Профилактика"}, {name: "Закрытие"}])
end

unless UserRole.all.any?
  user_role = UserRole.create!([{role: "Admin"}, {role: "User"}])
end
# Раскоментировать что бы сделать все работы подтвержденными
# Job.all.each do |job|
#   if job.accepted.nil?
#     job.update!(accepted: true)
#   end
# end

unless Staff.all.any?
  puts "Создание начальных значений стафа"
  Staff.create!([{name: "POS 566", staff_type: 0},
                {name: "POS 570", staff_type: 0},
                {name: "Server 3100", staff_type: 0},
                {name: "Server 3200", staff_type: 0},
                {name: "Server Lenovo", staff_type: 0},
                {name: "Server 3300", staff_type: 0},
                {name: "Касса", staff_type: 1},
                {name: "Подсобка", staff_type: 1},
                {name: "Сетевой шкаф", staff_type: 1},
                {name: "Кассовая зона", staff_type: 1},
                {name: "Рабочее место", staff_type: 1}])
end