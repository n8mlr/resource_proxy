require File.dirname(__FILE__) + '/test_helper.rb'


class CustomerResource < ActiveResource::Base
  self.site = "https://modeauth.modeoffitness.com/api/v1"
  self.element_name = "customer"
end

class SimpleProxyTest
  include ResourceProxy
  
  acts_as_resource_proxy do |config|
    config.resource_class = CustomerResource
    config.capturable = [:login]
  end
end

class ResourceProxyTest < ActiveSupport::TestCase

  def test_has_resource
    assert_equal CustomerResource, SimpleProxyTest.resource_class
  end
  
  def test_builds_resource_on_init
    prox = SimpleProxyTest.new
    assert_kind_of CustomerResource, prox.resource
  end
  
  def test_creates_instance_variables_from_hash
    prox = SimpleProxyTest.new({"login" => "nate"})
    assert_equal "nate", prox.login
  end
  
  def test_save_will_save_resource
    prox = SimpleProxyTest.new({"login" => "bart"})
    prox.resource.expects(:save).returns(true)
    prox.save
  end
  
  def test_initializing_with_paramerts_skips_non_capturable_fields
    CustomerResource.expects(:new).with({"login" => "jake"})
    prox = SimpleProxyTest.new({"login" => "jake", "bad_field" => "nope" })
  end
  
  def test_calling_find_with_all_fetches_all_record
    CustomerResource.expects(:find).with(:all).returns([])
    SimpleProxyTest.find(:all)
  end
  
  def test_calling_find_with_unsupported_arg_raises_error
    assert_raises ResourceProxy::UnsupportedFindMethod do
      SimpleProxyTest.find(:foobar)
    end
  end
  
  def test_find_an_object_with_id_returns_object
    CustomerResource.expects(:find).with(1).returns({})
    SimpleProxyTest.find(1)
  end
  
  # def test_errors_from_resource_transfer_to_proxy
  #   prox = SimpleProxyTest.new({"login" => nil})
  #   prox.expects(:save).returns(false)
  #   prox.stubs(:errors).returns({"login" => ["should not be blank"]})
  #   prox.errors_on(:login)
  #   assert prox.errors_on(:login).includes?(["should not be blan"]), true
  # end
end
