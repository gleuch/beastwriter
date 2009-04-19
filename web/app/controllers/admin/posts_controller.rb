class Admin::PostsController < Admin::ApplicationController

  before_filter :load_objects
  uses_tiny_mce

  def index
    @posts = Post.find(:all, :order => "id desc")

    respond_to do |format|
      format.html
      format.xml { render :xml => @posts }
      format.json { render :json => @posts }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:success] = 'Post was successfully created'
        format.html { redirect_to(admin_post_path(@post)) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
  end

  def update
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:success] = 'Post was successfully updated'
        format.html { redirect_to(admin_post_path(@post)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(admin_posts_path) }
      format.xml  { head :ok }
    end
  end


  private

  def load_objects
    @post = Post.find_by_permalink(params[:id]) if params[:id]
    @post = Post.find_by_permalink(params[:post_id]) if params[:post_id]
  end

end