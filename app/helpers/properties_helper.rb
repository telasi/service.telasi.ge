# -*- encoding : utf-8 -*-
module PropertiesHelper

  def common_table(models, opts = {})
    header = ''
    opts[:columns].each do |col, props|
      header += %Q{<th width="#{props[:width]}">#{props[:label]}</th>}
    end
    body = ''
    models.each do |model|
      body += '<tr>'
      opts[:columns].each do |key, props|
        body += %Q{<td class="#{props[:class]}">}
        if props[:action]
          body += %Q{<a href="#{ props[:action].call(model) }">#{ cell_content(model, key, props) }</a>}
        else
          body += %Q{#{cell_content(model, key, props)}}
        end
        body += %Q{</th>}
      end
      body += '</tr>'
    end
    %{
      <table class="table table-striped table-condensed table-bordered">
      <thead><tr>#{header}</tr></thead>
      <tbody>#{body}</tbody>
      </table>
      }.html_safe
  end

  def properties_table(model, opts = {})
    col1 = column_content(model, opts[:col1]) if opts[:col1]
    col2 = column_content(model, opts[:col2]) if opts[:col2]
    if col2
      cols = %Q{
        <div class="row">
        <div class="span6">#{col1}</div>
        <div class="span6">#{col2}</div>
        </div>
      }.html_safe
    else
      cols = %Q{
        <div class="row">
        <div class="span12">#{col1}</div>
        </div>
      }
    end
    actions = property_actions(opts[:actions]) if opts[:actions]
    %Q{
      <div class="properties">
      <div class="title">
        <div class="actions">#{actions}</div>
        #{image_tag(opts[:icon]) if opts[:icon]}
        #{opts[:title]}
      </div>
      #{cols}
      </div>
    }.html_safe
  end

  private

  def property_actions(actions)
    html = ''
    actions.each do |label, url|
      html += %Q{<a href="#{url}">#{label}</a>}
    end
    html
  end

  def column_content(model, cols)
    rows = ""
    cols.each do |key, col|
      opts = {}
      if col.is_a? String
        label = col
      else
        label = col[:label]
        opts = col
      end
      rows += %Q{
        <tr>
        <td width="150"><b>#{label}</b</td>
        <td>#{cell_content(model, key, opts)}</td>
        </tr>
      }
    end
    %Q{<table class="table table-striped table-condensed">#{rows}</table>}.html_safe
  end

  def cell_content(model, key, opts = {})
    postfix = ''
    decimals = 2
    tag = 'span'
    postfix = opts[:post]
    decimals = opts[:decimals] || 2
    tag = opts[:tag] || 'span'
    %Q{
      <#{tag}>#{key_value(model, key, {decimals: decimals})}</#{tag}>
      #{postfix}
    }
  end

  def key_value(model, key, opts={})
    val = value_for(model, key)
    if val.is_a? String
      val = val.strip.to_ka
    elsif val.is_a? Boolean
      val = val ? 'კი' : 'არა'
    elsif val.is_a?(Float) || val.is_a?(BigDecimal)
      val = C12.number_format(val, 2)
    elsif val.is_a? NilClass
      val = '<span class="muted">ცარიელი</span>'
    elsif val.is_a? ActiveSupport::TimeWithZone
      val = val.strftime('%d-%b-%Y')
    end
    val
  end

  def value_for(model, key)
    val = model
    key.to_s.split('.').each do |k|
      val = val.send(k)
    end
    val
  rescue Exception => ex
    ex
  end

end
