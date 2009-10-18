class EntriesController < ApplicationController

  def index
    @entries = Entry.active.limit(5)
    set_title("Homepage")

    respond_to do |format|
      format.html
      format.xml { render :xml => @entries }
      format.json { render :json => @entries }
      format.atom
    end
  end

  def show
    set_xpingback_header
    @entry = Entry.active.find_by_permalink(params[:id]) if params[:id]
    @entry = Entry.active.find_by_permalink(params[:entry_id]) if params[:entry_id]
    set_title(@entry.title)

    respond_to do |format|
      format.html
      format.xml { render :xml => @entry }
      format.json { render :json => @entry }
    end
  end

  def archive
    @entries = Entry.active.find_by_date(params)
    set_title("Entries created #{return_date_selection(params)}")

    respond_to do |format|
      format.html
      format.xml { render :xml => @entries }
      format.json { render :json => @entries }
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
