# -*- encoding : utf-8 -*-
class Call::DocsController < Call::CallController
  def index
    @title = 'დოკუმენტები'
    @docs = Call::Doc.where(:order_by.gte => 0).asc(:order_by)
    navbuttons
  end

  def show
    @title = 'დოკუმენტები'
    @doc = Call::Doc.find(params[:id])
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'დოკუმენტები' => call_docs_url }
    if @doc
      @nav[@doc.title] = nil
    end
  end
end
