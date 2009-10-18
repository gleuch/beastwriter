class CommentsController < ApplicationController

  has_rakismet :only => :create

  def create
    @entry = Entry.find_by_permalink(params[:entry_id])
    @comment = @entry.comments.new(params[:comment])

    # If it thinks it's spam, just don't bother saving it at all
    unless @comment.spam?
      @comment.save!
    end

    respond_to do |format|
      format.html { redirect_to @entry }
      format.js
    end
  end

end
