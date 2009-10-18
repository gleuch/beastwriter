require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/new.html.erb" do
  define_models :sites_controller

  include SitesHelper
  
  before do
    @site = sites(:new)
    assigns[:site] = @site
  end

  it "should render new form" do
    render "/sites/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", sites_path) do
    end
  end
end


