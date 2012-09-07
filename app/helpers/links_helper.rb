# -*- encoding : utf-8 -*-
module LinksHelper

  def android_links(opts = {})
    opts[:android] = true
    header_links(opts)
  end

  def header_links(opts = {})
    h_links  = {'საწყისი' => home_url}
    h_links['Android'] = android_home_url if opts[:android]
    h_links = h_links.merge(opts[:links]) if opts[:links]
    h_links[opts[:title]] = opts[:url] if opts[:title]
    render partial: '/layouts/elements/header_links', locals: {links: h_links}
  end

end
