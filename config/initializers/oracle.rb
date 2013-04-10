# -*- encoding : utf-8 -*-

# GIS connection
Gis::Transformator.establish_connection :gis
Gis::SmsLog.establish_connection :gis
Gis::Section.establish_connection :gis
Gis::Fider.establish_connection :gis

# Region connections
Call::CutHistory::Didube.establish_connection :report_bs
