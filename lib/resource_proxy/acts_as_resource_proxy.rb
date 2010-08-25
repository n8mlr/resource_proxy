module ResourceProxy
  class UnsupportedFindMethod < StandardError; end
  
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    include ActiveSupport::CoreExtensions::String::Inflections
    
    # Central access point method
    def acts_as_resource_proxy(unsupported_options = nil, &block)
      cattr_accessor :resource_class
      cattr_accessor :capturable_attributes
      self.capturable_attributes = []
      send :include, InstanceMethods
      yield self if block_given?
    end
    
    # Set some ground rules for what can be catpured by this class
    def capturable=(attrs = [])
      attrs.each do |k|
        self.capturable_attributes << k.to_sym 
        # Write our dynamic getter setters
        define_method("#{k.to_sym}=") do |t|
          self.instance_variable_set("@#{k}", t)
          # hook into resource and add object
          self.resource.send(k.to_sym, t)
        end
        
        define_method(k.to_sym) do
          # Refine - need to make sure that our proxy object and
          # resource remain properly synchronized
          if self.resource
            return self.resource.send(k.to_sym)
          end
          self.instance_variable_get("@#{k}")
        end
      end
    end
    
    # Don't even try to act like this is ActiveRecord. Find will take the followin:
    #  :all - return all records
    #  ID - return record with id
    def find(*args)
      first_arg = args.first
      if first_arg.kind_of? Fixnum
        ob = self.new
        ob.resource = self.resource_class.find(first_arg)
        ob
      else
        if first_arg.to_sym == :all
          self.resource_class.find(:all)
        else
          raise ResourceProxy::UnsupportedFindMethod
        end
      end
    end
    
    # Delete from a hash any attributes which have not been declared in captureable=
    def filter_attributes(attr_hash = {})
      attr_hash.delete_if { |k,v| !self.capturable_attributes.include?(k.to_sym) }
      attr_hash
    end
  end

  module InstanceMethods
    attr_accessor :resource
    
    # If we receive a hash of values, like as we would through a Rails form request, 
    # we set an instance variable for each pair
    def initialize(attrs = {})
      @local_errors = []
      unless attrs.empty?
        filtered_attributes = self.class.filter_attributes(attrs)
        self.resource = self.resource_class.new(filtered_attributes)
        filtered_attributes.each do |k,v|
          ivar_name = k.underscore
          self.instance_variable_set("@#{ivar_name}", v)
        end
      end
    end
    
    # We save our resource model and report whether it succeeded
    def save
      @local_errors = []
      unless resource.save
        @local_errors = resource.errors
      end
      
      @local_errors.empty?
    end
    
    # Return all errors located on the resource
    def errors
      if resource
        @local_errors = resource.errors
      end
      @local_errors
    end

    def errors_on(attribute)
      
    end

    private
    
      # Create an attribute reader and writer method for each of 
      # the capturable attributes. These methods ensure sync between
      # the local proxy and the proxy object
      
    
    
  end
  
end
