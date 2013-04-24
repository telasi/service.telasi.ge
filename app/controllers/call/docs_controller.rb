# -*- encoding : utf-8 -*-
class Call::DocsController < Call::CallController

  def index
    @title = 'დოკუმენტები'
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'დოკუმენტები' => call_docs_url }
  end

end
