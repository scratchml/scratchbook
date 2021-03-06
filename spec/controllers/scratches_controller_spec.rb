require 'spec_helper'

describe ScratchesController do

  describe "GET #index" do
    it "works" do
      get :index
      response.should be_success
    end
  end

  describe "GET #show" do
    let(:scratch) { Factory.create(:scratch) }

    it "works" do
      get :show, :id => scratch.to_param
      response.should be_success
      assigns(:scratch).should == scratch
    end

    it ".xml works" do # aka .sml
      get :show, :id => scratch.to_param, :format => 'xml'
      response.should be_success
      xml = Nokogiri::XML.parse(response.body)
      xml.errors.should be_blank
    end

    it ".json works" do
      get :show, :id => scratch.to_param, :format => 'json'
      response.should be_success
      json = JSON.parse(response.body)
      json['data'].should_not be_blank
    end
  end

  describe "POST #create" do
    let(:valid_params) { {:data => fixture_file('scratchml.xml'), :application => 'Coolapp'} }

    it "works" do
      post :create, valid_params
      response.should be_success
      assigns(:scratch).should_not be_nil
    end

    it "fails without data" do
      post :create, :format => 'json'
      response.should_not be_success
      json = JSON.parse(response.body)
      json['success'].should == false
      json['errors'].should include('data is missing')
    end

    it "fails with invalid XML" do
      post :create, :data => 'not xml dude', :format => 'json'
      response.should_not be_success
      json = JSON.parse(response.body)
      json['success'].should == false
      json['errors'].should include('data is not valid XML')
    end
  end

  describe "PUT #update" do
    it "works"
  end

end
