# -*- encoding : utf-8 -*-

# GIS connection
Gis::Transformator.establish_connection :gis
Gis::SmsLog.establish_connection :gis
Gis::Section.establish_connection :gis
Gis::Fider.establish_connection :gis

# Region connections
Call::CutHistory::Avchala.establish_connection :report_bs
Call::CutHistory::Chugureti.establish_connection :report_bs
Call::CutHistory::DidiDigomi.establish_connection :report_bs
Call::CutHistory::Didube.establish_connection :report_bs
Call::CutHistory::Gldani.establish_connection :report_bs
Call::CutHistory::Isani.establish_connection :report_bs
Call::CutHistory::Lotkini.establish_connection :report_bs
Call::CutHistory::Mtatsminda.establish_connection :report_bs
Call::CutHistory::Saburtalo.establish_connection :report_bs
Call::CutHistory::Samgori.establish_connection :report_bs
Call::CutHistory::Sanzona.establish_connection :report_bs
Call::CutHistory::Varketili.establish_connection :report_bs
Call::CutHistory::Vake.establish_connection :report_bs
Call::CutHistory::Okrosubani.establish_connection :report_bs
