# -*- encoding : utf-8 -*-

# GIS connection
Gis::Transformator.establish_connection :gis
Gis::SmsLog.establish_connection :gis
Gis::Section.establish_connection :gis
Gis::Fider.establish_connection :gis

# Water payments
Bs::WaterPayment.establish_connection :region_call
Bs::CutHistory.establish_connection :region_call
Bs::CutGroups.establish_connection :region_call
Bs::LogDateAndroid.establish_connection :region_call
Bs::WaterExceptions.establish_connection :region_call


Gnerc::Cutter.establish_connection :gnerc
Gnerc::Queue.establish_connection :gnerc

#Gnerc::CutterTest.establish_connection :gnerc_test
#Gnerc::QueueTest.establish_connection :gnerc_test