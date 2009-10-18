class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_permalink(params[:id]) if params[:id]
    @category = Category.find_by_permalink(params[:category_id]) if params[:category_id]
    @entries = @category.entries.active if @category
    set_title("#{@category.name} Entries")

    respond_to do |format|
      format.html
      format.xml { render :xml => [@category, @entries] }
      format.json { render :json => [@category, @entries] }
      format.atom
    end
  end

end
