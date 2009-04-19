class Admin::CommentsController < Admin::ApplicationController

  before_filter :load_objects

  def index
    @comments = Comment.find(:all, :order => "id desc")

    respond_to do |format|
      format.html
      format.xml { render :xml => @comments }
      format.json { render :json => @comments }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @comment }
      format.json { render :json => @comment }
    end
  end

  def new
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @comment }
      format.json { render :json => @comment }
    end
  end

  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:success] = 'Comment was successfully created'
        format.html { redirect_to(admin_comment_path(@comment)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:success] = 'Comment was successfully updated'
        format.html { redirect_to(admin_comment_path(@comment)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end


  private

  def load_objects
    @comment = Comment.find_by_id(params[:id]) if params[:id]
    @comment = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
  end

end