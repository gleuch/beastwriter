class PostsController < ApplicationController

  def index
    @posts = Post.active.limit(5)
    set_title("Homepage")

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
    set_title("Posts created #{return_date_selection(params)}")

    respond_to do |format|
      format.html
      format.xml { render :xml => @posts }
      format.json { render :json => @posts }
    end
  end


  protected

  def return_date_selection(params)
    if params[:month] && params[:year] && params[:day]
      "on #{params[:day].to_i.ordinalize} #{month_name_from_number(params[:month])} #{params[:year]}"
    elsif params[:month] && params[:year]
      "in #{month_name_from_number(params[:month])} #{params[:year]}"
    elsif params[:year]
      "in #{params[:year]}"
    end
  end

end
