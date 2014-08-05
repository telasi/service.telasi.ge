# -*- encoding : utf-8 -*-
require 'uri'

module SearchHelper
  def search_form(search, opts = {})
    has_search = search.present? && search.values.any? { |x| x.present? and x != 'nil' }
    forma_for search, title: 'ძებნა', icon: '/assets/fff/magnifier.png', collapsible: true, collapsed: !has_search, method: 'get', model_name: 'search' do |f|
      yield f if block_given?
      f.submit 'ძებნა'
      f.bottom_action("#{URI(request.url).path}?search=clear", label: 'ფორმის გასუფთავება', icon: '/assets/fff/delete.png') if has_search
    end
  end
end
