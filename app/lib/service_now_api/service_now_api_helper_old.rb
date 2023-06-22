require 'net/http'
require 'net/https'
require 'json'

module ServiceNowApi
  class ServiceNowApiHelper
    class << self
      def create_sn_ppr(username, store_rozn, date_start, comment="Плановый выезд", job_type="Профилактика", status="Запланировано")
        user_id, store_id = get_sys_id(username), get_sys_id(store_rozn)
        description = "#{status} #{job_type} на #{date_start}"
        if user_id && store_id
          create_task(user_id, store_id, description, comment)
        end
      end
      private
      @@headers = {
          "Authorization": "Basic Z2pfcmVzdDpCV0liV1BNOQ==",
          "Content-Type": "Application/json",
          "Accept": "Application/json"
      }
      def create_task(user_id, store_id, description, comment)
        data = {
            ids: store_id,
            start_date: Time.now.strftime("%d/%m/%Y %H:%M:%S"),
            short_desc: description,
            descr: comment,
            user: user_id,
            assig_group: "f545924adbd3fe00ab0cf3361d9619da"
        }.to_json
        uri = URI.parse("https://gjtest.service-now.com/api/gjoao/gj_post_ppr")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, @@headers)
        req.body = data
        res = https.request(req)
        res.body.first['status']
      end

      def get_sys_id(entity_name)
        data = {
            user_name: entity_name
        }.to_json
        uri = URI.parse("https://gjtest.service-now.com/api/gjoao/gj_getusid")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, @@headers)
        req.body = data
        res = https.request(req)
        sys_id = JSON.parse(res.body)['result']['sys_id']
      end
    end
  end
end