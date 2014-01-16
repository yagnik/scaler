require 'spec_helper'

describe "Scaler" do
  describe "relative_path" do
    it "should return relative path from lib" do
      Scaler.relative_path("templates/job.rb.erb").should match("lib/templates/job.rb.erb")
    end
  end

  describe "settings" do
    it "should have loaded settings" do
      Scaler::Settings.should_not eq(nil)
    end
  end
end
