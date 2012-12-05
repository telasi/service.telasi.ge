# -*- encoding : utf-8 -*-
require 'cra'

class Cra::AddressCache
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :parent, class_name: 'Cra::AddressCache'

  field :cra_id,    type: Integer
  field :description, type: String
  field :description_full, type: String
  field :identificator, type: Integer
  field :identificator_text, type: String
  field :identificator_type, type: Integer
  field :identificator_type_text, type: String
  field :address,   type: String
  field :active,    type: Boolean

  index :cra_id, unique: true

  def path
    unless @__path_initialized
      path = []
      parent = self.parent
      while parent
        path << parent
        parent = parent.parent
      end
      @__path = path.reverse
      @__path_initialized = true
    end
    @__path
  end

  def self.init_from_cra(user, parent_id)
    parent_id = parent_id.to_i
    parent = Cra::AddressCache.where(cra_id: parent_id).first
    if parent.blank? and parent_id == CRA::ROOT_ID
      parent = Cra::AddressCache.new(cra_id: CRA::ROOT_ID,
        description: 'საწყისი', description_full: 'საწყისი',
        active: true)
        parent.save
    end
    if parent
      children = CRA.serv.address_by_parent(parent_id) rescue []
      Cra::History.make_log(user)
      children.each do |child|
        c = Cra::AddressCache.where(cra_id: child.id).first || Cra::AddressCache.new
        c.cra_id = child.id
        c.active = child.active
        c.parent = parent
        c.description = child.description
        c.description_full = child.description_full
        c.identificator = child.identificator
        c.identificator_text = child.identificator_text
        c.identificator_type = child.identificator_type
        c.identificator_type_text = child.identificator_type_text
        c.address = child.address
        c.active = child.active
        c.save
      end
    end
  end

end
