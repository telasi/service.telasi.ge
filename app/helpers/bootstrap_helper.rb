# -*- encoding : utf-8 -*-
module BootstrapHelper

  def bootstrap_alert(text, opts = {})
    %Q{<div class="alert alert-#{opts[:class] || 'warning'} fade in"><a class="close" data-dismiss="alert" href="#">&times;</a>#{text}</div>}.html_safe unless text.blank?
  end

  def icon(icn, opts = {})
    icon_text(icn, nil, opts)
  end

  def icon_text(icn, txt = nil, opts = {})
    icon_name = "icon-#{icn}"
    icon_name += " icon-white" if opts[:white]
    tooltip = opts[:tooltip] ? %Q{rel="tooltip" data-original-title="#{opts[:tooltip]}" data-placement="#{opts[:tooltip_placement] || 'top'}"} : nil
    %Q{<i class="#{icon_name}" #{tooltip}></i> #{txt}}.strip.html_safe
  end

  def tooltiped_text(text, tooltip, placement = 'top')
    %Q{<span rel="tooltip" data-original-title="#{tooltip}" data-placement="#{placement}">#{text}</span>}.html_safe
  end

  def paginate(items, opts = {})
    will_paginate items, :previous_label => '&larr;', :next_label => '&rarr;'
  end

end
