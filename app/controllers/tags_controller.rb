class TagsController < ApplicationController

  def show
    @tag = Tag.find_by_permalink(params[:id]) if params[:id]
    @tag = Tag.find_by_permalink(params[:tag_id]) if params[:tag_id]
    @entries = @tag.entries.active if @tag

    respond_to do |format|
      format.html
      format.xml { render :xml => [@tag, @entries] }
      format.json { render :json => [@tag, @entries] }
      format.atom
    end
  end

end
