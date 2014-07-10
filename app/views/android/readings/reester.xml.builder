xml.reester do
  xml << render(partial: 'android/readings/reester_header', locals: {route: @route})
  xml.items do
    @route.items.each do |item|
      xml.item do
        xml.id(item.rtstorekey)
        xml.sequence(item.read_seq)
        xml.account do
          xml.status(item.cur_status)
          xml.cut(item.cur_cut)
          xml.custkey(item.custkey)
          xml.acckey(item.acckey)
          xml.accnumb(item.accnumb.strip.to_ka)
          xml.accid(item.accid.strip.to_ka)
          xml.custname(item.custname.strip.to_ka)
          xml.address do
            tp = item.account.tp
            if tp.present?
              xml.full_address("#{item.account.address.to_s2} (tp ##{tp.accid})")
            else
              xml.full_address(item.account.address.to_s2)
            end
            xml.street_id(item.account.address.street.streetkey)
            xml.street_name(item.account.address.street.streetname.strip.to_ka)
            xml.house(item.account.address.house.strip.to_ka) if item.account.address.house
            xml.building(item.account.address.building.strip.to_ka) if item.account.address.building
            xml.porch(item.account.address.porch.strip.to_ka) if item.account.address.porch
            xml.flate(item.account.address.flate.strip.to_ka) if item.account.address.flate
          end
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
          xml.new_number item.new_mtnumb
          xml.new_coeff  item.new_mtkoef
          xml.new_seal_number item.new_sealnumb
        end
        xml.reading do
          xml.reading(item.new_reading)
          xml.reading_confirmed(item.confirmed)
          xml.previous_reading(item.prv_reading)
          xml.previous_reading_date(item.prv_readdate ? item.prv_readdate.strftime('%d-%b-%Y') : '')
          xml.previous_real_reading(item.prv_r_reading)
          xml.previous_real_reading_date(item.prv_r_readdate ? item.prv_r_readdate.strftime('%d-%b-%Y') : '')
          xml.note item.note
          xml.note_id item.note_id.present? ? item.note_id : 0
          xml.error_code item.error_code_ilia.present? ? item.error_code_ilia : 0
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
