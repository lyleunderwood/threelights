require 'spec_helper'

describe RedirectController do

  describe "GET 'catalog'" do
    it "should be successful" do
      get 'catalog'
      response.should be_success
    end
  end

  describe "GET 'album'" do
    it "should be successful" do
      get 'album'
      response.should be_success
    end
  end

  describe "GET 'image'" do
    it "should be successful" do
      get 'image'
      response.should be_success
    end
  end

end
