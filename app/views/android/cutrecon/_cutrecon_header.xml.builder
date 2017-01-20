xml.type(header.oper_code)
xml.cutblock(header.cutblock)
xml.cutgroup(header.cutgroup)
xml.opername(header.operator.persname.to_ka) if header.operator
xml.region(header.region.regionname.to_ka)
xml.mark_date(header.oper_date.strftime('%Y-%m-%d %H:%M:%S'))