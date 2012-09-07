# -*- encoding : utf-8 -*-
module LinksHelper

  def header_links(opts = {})
    h_links  = {'საწყისი' => home_url}
    h_links['Android'] = android_home_url if opts[:android]
    h_links[:title] = opts[:url] if opts[:title]
    render partial: '/layouts/elements/header_links', locals: {links: h_links}
  end

end
