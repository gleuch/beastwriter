class Admin::EntriesController < Admin::ApplicationController

  before_filter :load_objects
  uses_tiny_mce

  def index
    @entries = Entry.find(:all, :order => "id desc")

    respond_to do |format|
      format.html
      format.xml { render :xml => @entries }
      format.json { render :json => @entries }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @entry }
      format.json { render :json => @entry }
    end
  end

  def new
    @entry = Entry.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @entry }
      format.json { render :json => @entry }
    end
  end

  def create
    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        flash[:success] = 'Entry was successfully created'
        format.html { redirect_to(admin_entry_path(@entry)) }
        format.xml  { render :xml => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @entry }
      format.json { render :json => @entry }
    end
  end

  def update
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:success] = 'Entry was successfully updated'
        format.html { redirect_to(admin_entry_path(@entry)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(admin_entries_path) }
      format.xml  { head :ok }
    end
  end


  private

  def load_objects
    @entry = Entry.find_by_permalink(params[:id]) if params[:id]
    @entry = Entry.find_by_permalink(params[:entry_id]) if params[:entry_id]
  end

end