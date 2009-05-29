class PostsController < ApplicationController

  def index
    @posts = Post.active.limit(5)

    respond_to do |format|
      format.html
      format.xml { render :xml => @posts }
      format.json { render :json => @posts }
      format.atom
    end
  end

  def show
    set_xpingback_header
    @post = Post.active.find_by_permalink(params[:id]) if params[:id]
    @post = Post.active.find_by_permalink(params[:post_id]) if params[:post_id]
    set_title(@post.title)

    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
  end

  def archive
    @posts = Post.active.find_by_date(params)

    respond_to do |format|
      format.html
      format.xml { render :xml => @posts }
      format.json { render :json => @posts }
    end
  end

end
