class TagsController < ApplicationController

  def show
    @tag = Tag.find_by_permalink(params[:id]) if params[:id]
    @tag = Tag.find_by_permalink(params[:tag_id]) if params[:tag_id]
    @posts = @tag.posts.active if @tag

    respond_to do |format|
      format.html
      format.xml { render :xml => [@tag, @posts] }
      format.json { render :json => [@tag, @posts] }
      format.atom
    end
  end

end
