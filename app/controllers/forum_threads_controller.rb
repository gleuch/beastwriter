class ForumThreadsController < ApplicationController
  before_filter :find_forum
  before_filter :find_thread, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { redirect_to forum_path(@forum) }
      format.xml  do
        @threads = find_forum.threads.paginate(:page => current_page)
        render :xml  => @threads
      end
    end
  end
  
  def edit
  end

  def show
    respond_to do |format|
      format.html do
        if logged_in?
          current_user.seen!
          (session[:threads] ||= {})[@thread.id] = Time.now.utc
        end
        @thread.hit! unless logged_in? && @thread.user_id == current_user.id
        @posts = @thread.posts.paginate :page => current_page
        @post  = ForumPost.new
      end
      format.xml  { render :xml  => @thread }
    end
  end

  def new
    @thread = ForumThread.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml  => @thread }
    end
  end

  def create
    @thread = current_user.post(@forum, params[:thread])

    respond_to do |format|
      if @thread.new_record?
        format.html { render :action => "new" }
        format.xml  { render :xml  => @thread.errors, :status => :unprocessable_entity }
      else
        flash[:notice] = 'Thread was successfully created.'
        format.html { redirect_to(forum_thread_path(@forum, @thread)) }
        format.xml  { render :xml  => @thread, :status => :created, :location => forum_thread_url(@forum, @thread) }
      end
    end
  end

  def update
    current_user.revise @thread, params[:thread]
    respond_to do |format|
      if @thread.errors.empty?
        flash[:notice] = 'Thread was successfully updated.'
        format.html { redirect_to(forum_thread_path(@forum, @thread)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @thread.destroy

    respond_to do |format|
      format.html { redirect_to(@forum) }
      format.xml  { head :ok }
    end
  end

protected
  def find_forum
    @forum = Forum.find_by_permalink(params[:forum_id])
  end
  
  def find_thread
    @thread = @forum.threads.find_by_permalink(params[:id])
  end
end
