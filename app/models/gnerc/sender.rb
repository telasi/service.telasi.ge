# -*- encoding : utf-8 -*-
module Gnerc::Sender

	def self.stage2(item)
		return if ( item.mark_code == 0 or item.mark_code == 2 )
		#return if [8, 51].include?(item.discrecstatuskey)

		Gnerc::Cutter.transaction do
			cutter = Gnerc::Cutter.where(transaction_number: item.cr_key).first
			return unless cutter.present?

			if item.mark_code == 2
				discrecstatus = Bs::Discrecstatusdet.find(item.discrecstatuskey)
				cutter.update_attributes!(note: discrecstatus.name.to_ka) if discrecstatus.present?
			end

			cutter.update_attributes!(stage: 2, transaction_number_2: cutter.transaction_number, request_status: cutter.mark_code)
			cutter.update_attributes!(compare_date_2: item.enter_date_insp) if cutter.compare_date_2.blank?

			if cutter.mainaccount == 1
				if Gnerc::Queue.where(service: Gnerc::Queue::SERVICE, service_id: cutter.id, stage: 2).blank?
				 queue = Gnerc::Queue.new(service: Gnerc::Queue::SERVICE, service_id: cutter.id, stage: 2, created_at: Time.now + 4.hours, updated_at: Time.now  + 4.hours)
				 queue.save!
				end
			end
		end

		# # NEW
		# Gnerc::CutterTest.transaction do
		# 	cuttertest = Gnerc::CutterTest.where(transaction_number: item.cr_key).first
		# 	return unless cuttertest.present?

		# 	if item.mark_code == 2
		# 		discrecstatus = Bs::Discrecstatusdet.find(item.discrecstatuskey)
		# 		cuttertest.update_attributes!(note: discrecstatus.name.to_ka) if discrecstatus.present?
		# 	end

		# 	cuttertest.update_attributes!(stage: 2, transaction_number_2: cuttertest.transaction_number)
		# 	cuttertest.update_attributes!(compare_date_2: item.enter_date_insp) if cuttertest.compare_date_2.blank?

		# 	if cuttertest.mainaccount == 1
		# 		if Gnerc::QueueTest.where(service: Gnerc::Queue::SERVICE, service_id: cuttertest.id, stage: 2).blank?
		# 		 queue = Gnerc::QueueTest.new(service: Gnerc::Queue::SERVICE, service_id: cuttertest.id, stage: 2, created_at: Time.now + 4.hours, updated_at: Time.now  + 4.hours)
		# 		 queue.save!
		# 		end
		# 	end
		# end
	end
end