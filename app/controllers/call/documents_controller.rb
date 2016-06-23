# -*- encoding : utf-8 -*-
class Call::DocumentsController < ApplicationController

  before_filter :require_admin_user, only: [:edit, :update, :destroy, :new, :create]

  # GET /call/documents
  # GET /call/documents.json
  def index
    @customnav = { 'მთავარი' => call_home_url,  'დოკუმენტები' => call_documents_url}
    @call_documents = Call::Document.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @call_documents }
    end
    

  end

  # GET /call/documents/1
  # GET /call/documents/1.json
  def show

    @call_document = Call::Document.find(params[:id])
    @customnav = { 'მთავარი' => call_home_url,  'დოკუმენტები' => call_documents_url,
                    @call_document.name => call_documents_url}
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call_document }
    end
  end

  # GET /call/documents/new
  # GET /call/documents/new.json
  def new
    @customnav = { 'მთავარი' => call_home_url,  'დოკუმენტები' => call_documents_url,
                    'ახალი დოკუმენტის შექმნა' => new_call_document_url}
    @call_document = Call::Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @call_document }
    end
  end

  # GET /call/documents/1/edit
  def edit
    @customnav = { 'მთავარი' => call_home_url,  'დოკუმენტები' => call_documents_url,
                    'ახალი დოკუმენტის შექმნა' => call_documents_url}    
    @call_document = Call::Document.find(params[:id])
  end

  # POST /call/documents
  # POST /call/documents.json
  def create
    @call_document = Call::Document.new(params[:call_document])

    respond_to do |format|
      if @call_document.save
        format.html { redirect_to @call_document, notice: 'Document was successfully created.' }
        format.json { render json: @call_document, status: :created, location: @call_document }
      else
        format.html { render action: "new" }
        format.json { render json: @call_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /call/documents/1
  # PUT /call/documents/1.json
  def update
    @call_document = Call::Document.find(params[:id])

    respond_to do |format|
      if @call_document.update_attributes(params[:call_document])
        format.html { redirect_to @call_document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /call/documents/1
  # DELETE /call/documents/1.json
  def destroy
    @call_document = Call::Document.find(params[:id])
    @call_document.destroy

    respond_to do |format|
      format.html { redirect_to call_documents_url }
      format.json { head :no_content }
    end
  end


private
    def require_admin_user
      has_action_permission = current_user.call_admin
      if !has_action_permission
        redirect_to call_documents_url, notice: 'თქვენს იუზერს არ აქვს ცვლილების უფლება'
      end
    end

end
