class Admin::LinksController < Admin::ApplicationController

  before_filter :load_objects

  def index
    @links = Link.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @links }
      format.json { render :json => @links }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @link }
      format.json { render :json => @link }
    end
  end

  def new
    @link = Link.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @link }
      format.json { render :json => @link }
    end
  end

  def create
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        flash[:success] = 'Link was successfully created'
        format.html { redirect_to(admin_category_path(@link)) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:success] = 'Link was successfully updated'
        format.html { redirect_to(admin_link_path(@link)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def load_objects
    @link = Link.find_by_id(params[:id]) if params[:id]
    @link = Link.find_by_id(params[:link_id]) if params[:link_id]
  end

end