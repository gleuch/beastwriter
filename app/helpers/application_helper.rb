require 'md5'
module ApplicationHelper

  def tree_select(categories, model, name, selected=0, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
      # Add "Root" to the options
      html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\">\n"
      html << "\t<option value=\"0\""
      html << " selected=\"selected\"" if selected.parent_id == 0
      html << ">Root</option>\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        html << ' selected="selected"' if cat.id == selected.parent_id
        html << ">#{cat.name}</option>\n"
        html << tree_select(cat.children, model, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('feed-icon.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end

  def pagination(collection)
    if collection.total_entries > 1
      "<p class='pages'>" + I18n.t('txt.pages', :default => 'Pages') + ": <strong>" + 
      will_paginate(collection, :inner_window => 10, :next_label => I18n.t('txt.page_next', :default => 'next'), :prev_label => I18n.t('txt.page_prev', :default => 'previous')) +
      "</strong></p>"
    end
  end
  
  def next_page(collection)
    unless collection.current_page == collection.total_entries or collection.total_entries == 0
      "<p style='float:right;'>" + link_to(I18n.t('txt.next_page', :default => 'next page'), { :page => collection.current_page.next }.merge(params.reject{|k,v| k=="page"})) + "</p>"
    end
  end

  def search_posts_title
    returning(params[:q].blank? ? I18n.t('txt.recent_posts', :default => 'Recent Posts') : I18n.t('txt.searching_for', :default => 'Searching for') + " '#{h params[:q]}'") do |title|
      title << " " + I18n.t('txt.by_user', :default => 'by {{user}}', :user => h(@user.display_name)) if @user
      title << " " + I18n.t('txt.in_forum', :default => 'in {{forum}}', :forum => h(@forum.name)) if @forum
    end
  end

  def thread_title_link(thread, options)
    if thread.title =~ /^\[([^\]]{1,15})\]((\s+)\w+.*)/
      "<span class='flag'>#{$1}</span>" + 
      link_to(h($2.strip), forum_thread_path(@forum, thread), options)
    else
      link_to(h(thread.title), forum_thread_path(@forum, thread), options)
    end
  end

  def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end

  def avatar_for(user, size=32)
    image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.md5(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
  end

  def search_path(atom = false)
    options = params[:q].blank? ? {} : {:q => params[:q]}
    prefix = 
      if @thread
        options.update :forum_thread_id => @thread, :forum_id => @forum
        :forum_thread
      elsif @forum
        options.update :forum_id => @forum
        :forum
      elsif @user
        options.update :user_id => @user
        :user
      else
        :search
      end
    atom ? send("#{prefix}_forum_posts_path", options.update(:format => :atom)) : send("#{prefix}_forum_posts_path", options)
  end

end
