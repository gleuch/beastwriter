class Admin::CategoriesController < Admin::ApplicationController

  before_filter :load_objects
  uses_tiny_mce

  def index
    @categories = Category.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @categories }
      format.json { render :json => @categories }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @category }
      format.json { render :json => @category }
    end
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @category }
      format.json { render :json => @category }
    end
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:success] = 'Category was successfully created'
        format.html { redirect_to(admin_category_path(@category)) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:success] = 'Category was successfully updated'
        format.html { redirect_to(admin_category_path(@category)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end


  private

  def load_objects
    @category = Category.find_by_permalink(params[:id]) if params[:id]
    @category = Category.find_by_permalink(params[:category_id]) if params[:category_id]
  end

end