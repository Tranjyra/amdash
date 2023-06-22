module Admin
  class AdminController < ApplicationController
    layout 'admin'
    before_action :admin?
    #before_action :task1

    def index; end

    def load_sql
      File.read(Rails.root.join('sql_queries', 'sand_query.sql'))
    end

    def downcase_row(row)
      downcaserow = {}
      row.each do |key, value|
        downcaserow.merge!("#{key.downcase}": value)
      end
      downcaserow
    end

    def task1
      query = load_sql
      require 'tiny_tds'
      client = TinyTds::Client.new username: "SDUserRead", password: "SDUserRead", dataserver: "REKS:49768", database: "referen"
      results = client.execute(query)

      t = Time.now

      if results.count>500
        results.each do |row|
          file = File.join(Rails.root, '1', 'myfile.txt')
          f1=File.open(file, 'a')
          f1.puts t.strftime("%I:%M%p")
          f1.close

          #Store.all.destroy_all
          #results.each do |row1|
            #Store.create!(downcase_row(row1))
          #end

        end
        Store.create!({:code=>"9999", :name=>"м-н Тестовый магазин", :baseidd=>"0000002", :region=>"Южный регион", :idd=>"00005550000000000", :time_start=>"10:00", :time_end=>"22:00", :opening_date=>"2020-08-10 00:00:00 +0000", :zone=>"UTC +03:00", :s_stat=>"Действует", :phone=>"8-800-500-82-82", :phoneext=>"", :email=>"rozn0@gloria-jeans.ru", :addr=>"ул. Максима-Горького"})

      end
    end

    private
    def admin?
      redirect_to root_path, danger: "У вас нет прав на просмотр данной страницы." unless current_user.admin?
    end
  end
end
