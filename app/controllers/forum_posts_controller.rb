class ForumPostsController < ApplicationController
  before_filter :find_parents
  before_filter :find_post, :only => [:edit, :update, :destroy]


  def index
    @posts = @parent.posts.search(params[:q], :page => current_page)
    @users = @user ? {@user.id => @user} : User.index_from(@posts)
    respond_to do |format|
      format.html
      format.atom
      format.xml  { render :xml  => @posts }
    end
  end

  def search
    @posts = ForumPost.search(params[:q], :page => current_page)
    @users = @user ? {@user.id => @user} : User.index_from(@posts)
    respond_to do |format|
      format.html { render :action => 'index'}
      format.atom { render :action => 'index'}
      format.xml  { render :xml  => @posts, :action => 'index' }
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to forum_thread_path(@forum, @thread) }
      format.xml  do
        find_post
        render :xml  => @post
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @post = current_user.reply @thread, params[:post][:body]

    respond_to do |format|
      if @post.new_record?
        format.html { redirect_to forum_thread_path(@forum, @thread) }
        format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
      else
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(forum_thread_post_path(@forum, @thread, @post, :anchor => dom_id(@post))) }
        format.xml  { render :xml  => @post, :status => :created, :location => forum_thread_post_url(@forum, @thread, @post) }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(forum_thread_path(@forum, @thread, :anchor => dom_id(@post))) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(forum_thread_path(@forum, @thread)) }
      format.xml  { head :ok }
    end
  end

protected
  def find_parents
    if params[:user_id]
      @parent = @user = User.find(params[:user_id])
    elsif params[:forum_id]
      @parent = @forum = Forum.find_by_permalink(params[:forum_id])
      @parent = @thread = @forum.threads.find_by_permalink(params[:forum_thread_id]) if params[:forum_thread_id]
    end
  end

  def find_post
    post = @thread.posts.find(params[:id])
    if post.user == current_user || current_user.admin?
      @post = post
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end