xml.reester do
  xml.id(@route.route_header_id)
  xml.cycledate(@route.cycledate.strftime('%d-%b-%Y'))
  xml.inspector(@route.inspectorid)
  xml.downloads(@route.download_count + 1)
  xml.uploads(@route.upload_count)
  xml.status(@route.status)
  xml.items do
    @route.items.each do |item|
      xml.item do
        xml.id(item.rtstorekey)
        xml.route(item.routekey)
        xml.sequence(item.read_seq)
        xml.schedule(item.schedkey)
        xml.account do
          xml.status(item.cur_status)
          xml.cut(item.cur_cut)
          xml.custkey(item.custkey)
          xml.acckey(item.acckey)
          xml.accnumb(item.accnumb.strip.to_ka)
          xml.accid(item.accid.strip.to_ka)
          xml.custname(item.custname.strip.to_ka)
          xml.address(item.account.address.to_s)
        end
        xml.meter do
          xml.number(item.account.mtnumb ? item.account.mtnumb.strip.to_ka : '')
          xml.status(item.cur_mtstat)
          xml.seal_number(item.account.sealnumb ? item.account.sealnumb.strip.to_ka : '')
          xml.seal_status(item.cur_sealstat)
          xml.digits(item.cur_digit)
          xml.coeff(item.cur_mtkoef)
          xml.meter_type(item.account.meter_type.mtname.strip.to_ka) if item.account.meter_type
          xml.without_meter(item.account.meter_type.without_meter?) if item.account.meter_type
        end
        xml.reading do
          xml.reading(item.new_reading)
          xml.previous_reading(item.prv_reading)
          xml.previous_reading_date(item.prv_readdate ? item.prv_readdate.strftime('%d-%b-%Y') : '')
          xml.previous_real_reading(item.prv_r_reading)
          xml.previous_real_reading_date(item.prv_r_readdate ? item.prv_r_readdate.strftime('%d-%b-%Y') : '')
        end
        xml.other do
          xml.installed_capacity(item.cur_instcp)
          xml.min_charge(item.min_charge)
          xml.max_charge(item.max_charge)
          xml.min_balance(item.min_balance)
          xml.max_balance(item.max_balance)
        end
      end
    end
  end
end