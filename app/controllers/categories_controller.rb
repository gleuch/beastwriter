class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_permalink(params[:id]) if params[:id]
    @category = Category.find_by_permalink(params[:category_id]) if params[:category_id]
    @posts = @category.posts.active if @category
    set_title("#{@category.name} Posts")

    respond_to do |format|
      format.html
      format.xml { render :xml => [@category, @posts] }
      format.json { render :json => [@category, @posts] }
      format.atom
    end
  end

end
