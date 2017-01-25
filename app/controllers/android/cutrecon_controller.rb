# -*- encoding : utf-8 -*-
require 'xmlsimple' 

class Android::CutreconController < ApplicationController
  include Android::BsLoginController

  # რეესტრების სიის მიღება.
  def headers
    process_login('cut') do
      if @user && @user.bs_cut_person
        @routes = Bs::CutGroups
                           .where(inspector: @user.bs_cut_person)
                           .where("STATUS IN (?) ", [1,2])
                           .where(oper_code: params[:type])
                           .includes(:operator, :region)
      else
        @message = "რეესტრი ვერ მოიძებნა."
        render partial: 'android/readings/error'
      end
    end
  end

  def headerstatus
    process_login('cut') do
      if @user && @user.bs_cut_person
        @header = Bs::CutGroups
                           .where(cutgroup: params[:cutgroup])
                           .where(inspector: @user.bs_cut_person)
                           .where(oper_code: params[:type]).first
        render json: { success: true, status: @header.status } 
      else
        render json: { success: false } 
      end
    end
  end

  # რეესტრის გაგზავნა.
  def details
    process_login('cut') do
      if params[:cutgroup]
        @route = Bs::CutGroups
                         .includes(:operator)
                         .where(cutgroup: params[:cutgroup])
                         .first
      end
      unless @route
        @message = "რეესტრი ვერ მოიძებნა."
        render partial: 'android/readings/error'
      else
       @route.download_count = (@route.download_count||0)+1
       @route.status = Bs::RouteStoreHeader::STATUS_SENT if @route.status == Bs::RouteStoreHeader::STATUS_DEFAULT
       @route.save
      end
    end
  end

  def discrecstatus
    @discrecstatuses = Bs::Discrecstatusdet.includes(:discrecstatus).where("STATUS IN (?)", [0, 1])
  end

  def detail
    process_login('cut') do
      data = XmlSimple.xml_in(params[:detail])
      item = Bs::CutHistory.find(data['cr_key'][0])
      Bs::CutHistory.transaction do
        item.reading = data['reading'][0]
        item.note = data['note'][0].to_geo if data['note'][0].present?
        if item.upload_status == Bs::CutHistory::UPLOAD_STATUS_GNERC
          item.mark_code_insp = data['mark_code'][0]
          item.discrecstatuskey_insp = data['discrecstatuskey'][0] unless data['discrecstatuskey'][0] == 0  
        else
          item.mark_code = data['mark_code'][0]
          item.discrecstatuskey = data['discrecstatuskey'][0] unless data['discrecstatuskey'][0] == 0
        end

        item.enter_date_insp = data['enter_date'][0]
        item.upload_date_insp = Time.now + 4.hours
        item.upload_status = Bs::CutHistory::UPLOAD_STATUS_INSPECTOR

        item.save!

        if Bs::CutHistory.where(cutgroup: item.cutgroup, upload_status: 0).empty?
           header = Bs::CutGroups.find(item.cutgroup)
           header.upload_count = ( header.upload_count || 0 ) + 1
           header.status = Bs::CutGroups::STATUS_RECEIVED
           header.save!
        end

      end

    end
  end

  def version
    apk = Android::Apk.new('./public/cutter.apk')
    if apk.present?
      render json: { success: true, version: apk.manifest.version_name } 
    else
      render json: { success: false } 
    end
  end

  def testlogin
    process_login('cut') do
      render json: { success: true } 
    end
  end

  def download
  end

  # რეესტრის მიღება.
  def upload
    process_login('cut') do
      data = XmlSimple.xml_in(params[:reester])
      route = Bs::RouteStoreHeader.find(data['id'][0])
      all_complete = true
      Bs::RouteStoreItem.transaction do
        data['items'][0]['item'].each do |xml_item|
          item = Bs::RouteStoreItem.find(xml_item['id'][0])
          item.new_reading = xml_item['reading'][0]['reading'][0].to_f
          item.note=xml_item['reading'][0]['note'][0].to_geo rescue ''
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
  end
end
