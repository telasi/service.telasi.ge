# -*- encoding : utf-8 -*-

# GIS connection
Gis::Transformator.establish_connection :gis
Gis::SmsLog.establish_connection :gis
Gis::Section.establish_connection :gis
Gis::Fider.establish_connection :gis

# Water payments
Bs::WaterPayment.establish_connection :region_bs
Bs::CutHistory.establish_connection :region_bs
