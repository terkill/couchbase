require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class CouchbaseBucket < Resource
      include Couchbase::CredentialsAttributes

      def bucket(arg=nil)
        set_or_return(:bucket, arg, :kind_of => String, :name_attribute => true)
      end

      def cluster(arg=nil)
        set_or_return(:cluster, arg, :kind_of => String, :default => "default")
      end

      def exists(arg=nil)
        set_or_return(:exists, arg, :kind_of => [TrueClass, FalseClass], :required => true)
      end
      
      def proxyport(arg=nil)
        set_or_return(:proxyport, arg, :kind_of => Integer)
      end

      def memory_quota_mb(arg=nil)
        set_or_return(:memory_quota_mb, arg, :kind_of => Integer, :callbacks => {
          "must be at least 100" => lambda { |quota| quota >= 100 },
      	})
      end

      def memory_quota_percent(arg=nil)
        set_or_return(:memory_quota_percent, arg, :kind_of => Numeric, :callbacks => {
        	"must be a positive number" => lambda { |percent| percent > 0.0 },
        	"must be less than or equal to 1.0" => lambda { |percent| percent <= 1.0 },
      	})
      end

      def replicas(arg=nil)
        set_or_return(:replicas, arg, :kind_of => [Integer, FalseClass], :default => 1, :callbacks => {
        	"must be a non-negative integer" => lambda { |replicas| !replicas || replicas > -1 },
      	})
      end

      def type(arg=nil)
        set_or_return(:type, arg, :kind_of => String, :default => "couchbase", :callbacks => {
        	"must be either couchbase or memcached" => lambda { |type| %w(couchbase memcached).include? type },
      	})
      end

      def saslpassword(arg=nil)
        set_or_return(:saslpassword, arg, :kind_of => String, :default => "")
      end

      def disk_io_priority(arg=nil)
        set_or_return(:disk_io_priority, arg, :kind_of => String, :default => 'low', :callbacks => {
            'must be either low or high' => lambda { |type| %w(low high).include? type },
        })
      end

      def threads_number(arg=nil)
        set_or_return(:treads_number, arg, :kind_of => Integer, :callbacks => {
            "must be at least 1" => lambda { |threads| threads >= 1 },
        })
      end

      def metadata_ejection(arg=nil)
        set_or_return(:metadata_ejection, arg, :kind_of => String, :default => 'valueOnly', :callbacks => {
            'must be either valueOnly or fullEviction' => lambda { |type| %w(valueOnly fullEviction).include? type },
        })
      end

      def initialize(*)
        super
        @action = :create
        @allowed_actions.push :create
        @resource_name = :couchbase_bucket
      end
    end
  end
end
