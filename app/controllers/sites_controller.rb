class SitesController < ApplicationController
  before_filter :admin_required

  def index
    @sites = Site.paginate(:all, :page => current_page, :order => 'host ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  def new
    @site = Site.new :host => request.host

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        flash[:notice] = 'Site was successfully created.'
        flash[:notice] += ' Please create your account.' unless logged_in?
        format.html do
          redirect_to logged_in? ? @site : signup_path
        end
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_path) }
      format.xml  { head :ok }
    end
  end
  
  def authorized?
    @site.nil? or @site.new_record? #or current_site == Site.find(:first)
  end
end
