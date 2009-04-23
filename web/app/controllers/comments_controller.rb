class CommentsController < ApplicationController

  has_rakismet :only => :create

  def create
    @post = Post.find_by_permalink(params[:post_id])
    @comment = @post.comments.new(params[:comment])

    # If it thinks it's spam, just don't bother saving it at all
    unless @comment.spam?
      @comment.save!
    end

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

end
