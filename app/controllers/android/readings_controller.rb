# -*- encoding : utf-8 -*-
require 'xmlsimple' 

class Android::ReadingsController < ApplicationController
  include Android::BsLoginController

  # რეესტრების სიის მიღება.
  def reesters
    process_login do
      rel = Bs::RouteStoreHeader
      if params[:perskey]
        @inspector = Bs::Person.find(params[:perskey])
        rel = rel.where(inspectorid: params[:perskey])
      elsif params[:blockkey]
        @block = Bs::Block.find(params[:blockkey])
        rel = rel.joins(:route).where('route.blockkey=?', params[:blockkey])
      elsif params[:regionkey]
        @region = Bs::Region.find(params[:regionkey])
        rel = rel.joins(:route => :block).where('block.regionkey=?', params[:regionkey])
      end
      rel=rel.where('cycledate>?', Date.today-10)
      @routes = rel.paginate(per_page: 30, page: params[:page]).order('route_header_id DESC')
    end
  end

  # რეესტრის გაგზავნა.
  def reester
    process_login do
      if params[:id]
        @route = Bs::RouteStoreHeader.where(route_header_id: params[:id]).first
      else
        date = Date.strptime params[:date], '%d-%b-%Y' unless params[:date].blank?
        @route = Bs::RouteStoreHeader.where(cycledate: date, inspectorid: @user.bs_person).first
      end
      unless @route
        @message = "რეესტრი ვერ მოიძებნა."
        render partial: 'android/readings/error'
      else
        unless params[:count_downloads] == 'false'
          @route.download_count += 1
          @route.status = Bs::RouteStoreHeader::STATUS_SENT if @route.status == Bs::RouteStoreHeader::STATUS_DEFAULT
          @route.save
        end
      end
    end
  end

  # რეესტრის მიღება.
  def upload
    process_login do
      data = XmlSimple.xml_in(params[:reester])
      route = Bs::RouteStoreHeader.find(data['id'][0])
      all_complete = true
      Bs::RouteStoreItem.transaction do
        data['items'][0]['item'].each do |xml_item|
          item = Bs::RouteStoreItem.find(xml_item['id'][0])
          item.new_reading = xml_item['reading'][0]['reading'][0].to_f
          item.note=xml_item['reading'][0]['note'][0] rescue ''
          item.note_id=xml_item['reading'][0]['note_id'][0].to_i rescue 0
          item.error_code_ilia = xml_item['reading'][0]['error_code'][0].to_i rescue 0
          meter=(xml_item['meter'] and xml_item['meter'][0])
          if meter
            item.new_mtnumb   = meter['new_number'][0] if meter['new_number']
            item.new_mtkoef   = meter['new_coeff'][0] if meter['new_coeff']
            item.new_sealnumb = meter['new_seal_number'][0] if meter['new_seal_number']
          end
          if xml_item['reading'][0]['reading_confirmed'][0] == 'true'
            item.confirmed = true
          else
            item.confirmed = false
            all_complete   = false
          end
          item.save!
        end
        route.upload_count = (route.upload_count||0)+1
        if all_complete
          route.status = Bs::RouteStoreHeader::STATUS_RECEIVED
        else
          route.status = Bs::RouteStoreHeader::STATUS_SENT
        end
        route.save!
      end
    end
  end

  # მარშრუტის სინქრონიზაცია.
  def sync_route
    process_login do
      route = Bs::RouteStoreHeader.find(params[:id])
      ActiveRecord::Base.connection.execute("begin BS.android_pack.sync_route(#{route.route_header_id}); end;")
      route.status = Bs::RouteStoreHeader::STATUS_SYNCED
      route.save
      redirect_to android_route_url(route), notice: 'მარშრუტი სინქრონიზირებულია'
    end
  end
end
