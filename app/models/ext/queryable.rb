# -*- encoding : utf-8 -*-
module Ext::Queryable
  module ClassMethods
    def search_by_q(q, *fields)
      words = q.split #.find_all{|word| word[0] != '@'} unless q.blank?
      unless words.nil? or words.empty?
        ary = words.map{ |w| { '$or' => fields.map {|f| {f => /#{Regexp::escape(w)}/i} } } }
        where('$and' => ary)
      else
        where
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
