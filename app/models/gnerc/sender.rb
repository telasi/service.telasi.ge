# -*- encoding : utf-8 -*-
module Gnerc::Sender

	def self.stage2(item)
		return if item.mark_code == 0

		Gnerc::Cutter.transaction do
			cutter = Gnerc::Cutter.where(transaction_number: item.cr_key).first
			return unless cutter.present?

			if item.mark_code == 2
				discrecstatus = Bs::Discrecstatusdet.find(item.discrecstatuskey)
				cutter.update_attributes!(note: discrecstatus.name.to_ka) if discrecstatus.present?
			end

			cutter.update_attributes!(stage: 2, transaction_number_2: cutter.transaction_number, compare_date_2: item.enter_date_insp)

			if cutter.mainaccount == 1
				queue = Gnerc::Queue.new(service: Gnerc::Queue::SERVICE, service_id: cutter.id, stage: 2, created_at: Time.now, updated_at: Time.now)
				queue.save!
			end
		end
	end
end