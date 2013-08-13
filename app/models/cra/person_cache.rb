# -*- encoding : utf-8 -*-
require 'cra'

class Cra::PersonCache
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :address, class_name: 'Cra::AddressCache'
  field :private_number, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :birth_date, type: Date
  field :address_text, type: String

  index({ address_id: 1 })

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.init_from_cra(user, address)
    if address
      persons = CRA.serv.persons_at_address(address.cra_id) rescue []
      Cra::History.make_log(user)
      persons.each do |person|
        p = Cra::PersonCache.where(private_number: person.private_number, address_id: address.id).first || Cra::PersonCache.new
        p.private_number = person.private_number
        p.address = address
        p.first_name = person.first_name
        p.last_name = person.last_name
        p.birth_date = person.birth_date
        p.address_text = person.address
        p.save
      end
    end
  end

end
