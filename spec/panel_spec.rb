require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rubyvis::Panel do
  it "should be created as Javascript" do
    w,h=200,100
    vis = Rubyvis.Panel.new.width(w).height(h).margin(19.5).right(40)
  end
  
end