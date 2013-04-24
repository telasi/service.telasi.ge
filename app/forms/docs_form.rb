# -*- encoding : utf-8 -*-
module DocsForm
  include Dima::Html

  def self.docs_table(docs)
    tbl = Table.new(title: 'დოკუმენტები', icon: '/assets/fff/book.png')
    url = lambda{|v| Rails.application.routes.url_helpers.call_show_doc_path(id: v.id) }
    tbl.cols << TextField.new(name: 'order_by', label: '#')
    tbl.cols << TextField.new(name: 'title', label: 'სათაური', url: url)
    tbl.vals = docs
    tbl
  end

  def self.admin_docs_table(docs)
    tbl = Table.new(title: 'დოკუმენტები', icon: '/assets/fff/book.png')
    tbl.cols << TextField.new(name: 'order_by', label: '#')
    tbl.cols << TextField.new(name: 'title', label: 'სათაური')
    tbl.cols << TextField.new(name: 'file', label: 'ფაილი')
    url1 = Rails.application.routes.url_helpers.call_new_doc_path
    url2 = lambda{|v| Rails.application.routes.url_helpers.call_edit_doc_path(id: v.id) }
    url3 = lambda{|v| Rails.application.routes.url_helpers.call_delete_doc_path(id: v.id) }
    tbl.actions << Action.new(label: 'ახალი დოკუმენტი', icon: '/assets/fff/add.png', url: url1)
    tbl.item_actions << Action.new(label: 'შეცვლა', icon: '/assets/fff/pencil.png', url: url2)
    tbl.item_actions << Action.new(icon: '/assets/fff/delete.png', url: url3, method: 'delete', confirm: 'ნამდვილად გინდათ?')
    tbl.vals = docs
    tbl
  end

  def self.doc_form(doc, auth_token)
    form = Form.new(title: 'დოკუმენტი', icon: '/assets/fff/book_open.png', submit: 'შენახვა', auth_token: auth_token)
    form.col1 << NumberField.new(name: 'order_by', label: '#', precision: 0, required: true)
    form.col1 << TextField.new(name: 'title', label: 'სათაური', required: true)
    form.col1 << TextField.new(name: 'file', label: 'ფაილი', required: true)
    form.col1 << TextField.new(name: 'text', label: 'ტექსტი', textarea: true, width: 700, height: 300, original: true)
    form << doc
    form
  end

end
