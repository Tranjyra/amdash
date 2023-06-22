namespace :db do
  desc "Import files from csv data"
  task import_csv: :environment do
    require 'csv'
    CSV.foreach(Rails.root.join('data', 'stores.csv'), headers: true, encoding: "bom|utf8", header_converters: :symbol, col_sep: ';') do |row|
      Store.create!(row.to_h)
    end
  end

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
  task sync_sandbox: :environment do

    query = load_sql
    require 'tiny_tds'
    client = TinyTds::Client.new username: "SDUserRead", password: "SDUserRead", dataserver: "REKS:49768", database: "referen"
    results = client.execute(query)

    if results.count>500
        Store.all.destroy_all
        results.each do |row|
          Store.create!(downcase_row(row))
        end
        Store.create!({:code=>"9999", :name=>"м-н Тестовый магазин", :baseidd=>"0000002", :region=>"Южный регион", :idd=>"00005550000000000", :time_start=>"10:00", :time_end=>"22:00", :opening_date=>"2020-08-10 00:00:00 +0000", :zone=>"UTC +03:00", :s_stat=>"Действует", :phone=>"8-800-500-82-82", :phoneext=>"", :email=>"rozn0@gloria-jeans.ru", :addr=>"ул. Максима-Горького"})
    end

  end






end
