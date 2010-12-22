require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_support/core_ext/hash/slice'

describe "ResourceDefaults" do
  before(:all) do
    ActionDispatch::Routing::Mapper.send :include, ResourceDefaults
  end

  before(:each) do
    @routes = ActionDispatch::Routing::RouteSet.new
  end

  describe "standard resources" do
    before(:each) do
      @routes.draw do
        resources :articles do
          put :publish, :on => :member
          get :search, :on => :collection

          resources :comments do
            put :approve, :on => :member
          end
        end

        resources :comments do
          put :approve, :on => :member
        end
      end
    end

    it "should have 25 routes" do
      # 3*7 defaults + publish + search + 2*approve
      routes_for(@routes).length.should == 25
    end
  end

  describe "defaulted resources" do
    before(:each) do
      @routes.draw do
        resource_defaults :comments do
          put :approve, :on => :member
        end

        resources :articles do
          put :publish, :on => :member
          get :search, :on => :collection

          resources :comments
        end

        resources :comments
      end
    end

    it "should have 25 routes" do
      # 3*7 defaults + publish + search + 2*approve
      routes_for(@routes).length.should == 25
    end
  end

  describe "scoped defaulted resources" do
    before(:each) do
      @routes.draw do
        namespace :admin do
          resource_defaults :comments do
            put :approve, :on => :member
          end

          resources :articles do
            put :publish, :on => :member
            get :search, :on => :collection

            resources :comments
          end
        end

        resources :comments
      end
    end

    it "should have 24 routes" do
      # 3*7 defaults + publish + search + approve
      routes_for(@routes).length.should == 24
    end
  end

  def routes_for(routes)
    # taken from Railties's routes.rake
    routes.routes.collect do |route|
        # TODO: The :index method is deprecated in 1.9 in favor of :key
        # but we don't have :key in 1.8.7. We can remove this check when
        # stop supporting 1.8.x
        key_method = Hash.method_defined?('key') ? 'key' : 'index'
        name = routes.named_routes.routes.send(key_method, route).to_s
        reqs = route.requirements.empty? ? "" : route.requirements.inspect
        {:name => name, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
      end
  end
end
