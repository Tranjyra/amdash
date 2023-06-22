require 'net/http'
require 'net/https'
require 'json'

module ServiceNowApi
  class ServiceNowApiHelper
    class << self
      def create_sn_ppr(username, store_rozn, date_start, comment="Плановый выезд", job_type="ППР", status="Запланировано")
        user_id = get_sys_id(username)
        store_id=get_sys_id(store_rozn)
        if user_id==0 || store_id==0
          Rails.logger.debug "[SN RITM Creation FAILED!]:"
          Rails.logger.debug "[SN RITM Couldn't retrieve user/store sys_id!]:"
          [0,0]
          return
        end
        sh_desc= "#{job_type} от #{date_start}"
        description = "#{status} #{job_type} от #{date_start}"
        if comment.blank?
          comment="Плановый выезд"
        end

        if user_id && store_id
           create_RITM(user_id, store_id, sh_desc, description, comment)
        end
      end

      def create_sn_task(username, store_name, assignment_group, assigned_to, parent_sys_id, comment="Плановый выезд", job_type="ППР", status="Запланировано")
       # user_id = get_sys_id(username)
       # store_id=get_sys_id(store_rozn)

        if comment.blank?
          comment="Плановый выезд"
        end

        #if user_id && store_id
          create_TASK(username, store_name, assignment_group, assigned_to, parent_sys_id, comment)
        #end
      end

      private
      @@headers = {
          "Authorization": "Basic Z2pfcmVzdDpCV0liV1BNOQ==",
          "Content-Type": "Application/json",
          "Accept": "Application/json"
      }
      def create_RITM(user_id, store_id, sh_desc,description, comment)
        data = {
            start_date: Time.now.strftime("%d/%m/%Y %H:%M:%S"),
            caller_id:user_id,
            assignment_group:"f545924adbd3fe00ab0cf3361d9619da",
            short_description: sh_desc,
            description:sh_desc,
            comments:comment,

            u_category:"22a9bb26dbe932407d47f1c41d9619c5",
            u_item:"99864bd8db58070012b3fd431d961920",
            u_user:store_id,
            assigned_to:user_id
        }.to_json

        Rails.logger.debug "[SN RITM Creation Start]:"

        #22a9bb26dbe932407d47f1c41d9619c5 - Каталог услуг для магазинов u_category
        #99864bd8db58070012b3fd431d961920 - ППР u_item

        #uri = URI.parse("https://gjtest.service-now.com/api/gjoao/gj_post_ppr")
        #uri = URI.parse("https://gjtest.service-now.com/api/now/table/incident")

        #uri = URI.parse(Constants::SN_LINK+"/api/now/table/sc_req_item")
        uri = URI.parse(Constants::SN_LINK+"/api/now/table/sc_req_item")

        begin
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, @@headers)
          req.body = data
          res = https.request(req)
          Rails.logger.debug "[SN RITM Creation Result:]:"
          Rails.logger.debug res.body.first['status']
          Rails.logger.debug res.body

          respresult = JSON.parse(res.body)
          sys_id=respresult['result']['sys_id']
          ritm_name=respresult['result']['number']


          Rails.logger.debug "SN Ritm Created Sys_id: "+sys_id
          Rails.logger.debug "SN Ritm Created Number: "+ritm_name

          if sys_id.length<6 || ritm_name.length<6
            [0,0]
          else
            [sys_id,ritm_name]
          end

        rescue => error
          Rails.logger.debug "[SN RITM Creation FAILED!]:"+error.inspect
          [0,0]
        end

      end


      def get_sys_id(entity_name)

        uri = URI.parse(Constants::SN_LINK+"/api/now/table/sys_user")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        #data1=URI.escape("user_name="+entity_name, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

        params= {"sysparm_query" => "user_name="+entity_name, "sysparm_fields" => "sys_id", "sysparm_limit" => "1"}
        #params = { :sysparm_query => "user_name="+entity_name, :sysparm_fields => "sys_id",:sysparm_limit => 1 }
        uri.query = URI.encode_www_form(params)
        req = Net::HTTP::Get.new(uri, @@headers)
        begin
          res = https.request(req)


          Rails.logger.debug "SN Request:"
          Rails.logger.debug req.uri
          Rails.logger.debug "SN Response:"
          Rails.logger.debug res.body.to_s


          respresult = JSON.parse(res.body)
          sys_id=respresult['result'].first['sys_id']

          Rails.logger.debug "SN Sys_id"
          Rails.logger.debug sys_id

          if sys_id.length<6
            0
          else
            sys_id
          end


        rescue => error
          Rails.logger.debug "[SN RITM sysid getting FAILED!]:"+error.inspect
          0
        end

      end







      def create_TASK(username, store_name, assignment_group, assigned_to, parent_sys_id, commnet)
        data = {
            start_date: Time.now.strftime("%d/%m/%Y %H:%M:%S"),
            #caller_id:user_id,
            assignment_group:"f545924adbd3fe00ab0cf3361d9619da",
            #short_description: sh_desc,
            #description:sh_desc,
            comments:comment

            #u_category:"22a9bb26dbe932407d47f1c41d9619c5",
            #u_item:"99864bd8db58070012b3fd431d961920"
        }.to_json

        Rails.logger.debug "[SN TASK Creation Start]:"

        #22a9bb26dbe932407d47f1c41d9619c5 - Каталог услуг для магазинов u_category
        #99864bd8db58070012b3fd431d961920 - ППР u_item

        #uri = URI.parse("https://gjtest.service-now.com/api/gjoao/gj_post_ppr")
        #uri = URI.parse("https://gjtest.service-now.com/api/now/table/incident")

        #uri = URI.parse(Constants::SN_LINK+"/api/now/table/sc_req_item")
        uri = URI.parse(Constants::SN_LINK+"/api/now/table/sc_task_item")

        begin
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, @@headers)
          req.body = data
          res = https.request(req)
          Rails.logger.debug "[SN TASK Creation Result:]:"
          Rails.logger.debug res.body.first['status']
          Rails.logger.debug res.body

          respresult = JSON.parse(res.body)
          sys_id=respresult['result']['sys_id']
          ritm_name=respresult['result']['number']


          Rails.logger.debug "SN TASK Created Sys_id: "+sys_id
          Rails.logger.debug "SN TASK Created Number: "+ritm_name

          if sys_id.length<6 || ritm_name.length<6
            [0,0]
          else
            [sys_id,ritm_name]
          end

        rescue => error
          Rails.logger.debug "[SN TASK Creation FAILED!]:"+error.inspect
          [0,0]
        end

      end



    end
  end
end