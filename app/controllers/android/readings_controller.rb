# -*- encoding : utf-8 -*-
require 'xmlsimple' 

class Android::ReadingsController < ApplicationController

  include Android::BsLoginController

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
      Bs::RouteStoreItem.transaction do
        data['items'][0]['item'].each do |xml_item|
          item = Bs::RouteStoreItem.find(xml_item['id'][0]) #Bs::RouteStoreItem.where(rtstorekey: xml_item['id'][0]).first
          item.new_reading = xml_item['reading'][0]['reading'][0].to_f
          item.confirmed = xml_item['reading'][0]['reading_confirmed'][0] == 'true'
          item.save!
        end
        route.upload_count += 1
        route.save!
      end
    end
  end

end
