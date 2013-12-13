module Scaler
  module Ec2
    class Instance
      include Taggable

      attr_reader :ec2_instance, :type, :cluster_id, :security_group

      def initialize(ec2, cluster_id, type, security_group, args={})
        @type = type
        @cluster_id = cluster_id
        @security_group = security_group
        @ec2_instance = find_or_create(ec2, cluster_id, type, security_group, args)
      end

      def destroy
        @ec2_instance.terminate
      end

      def url
        @ec2_instance.public_dns_name
      end

      def wait(status)
        sleep 1 while @ec2_instance.status != status
      end

      private
      def find_or_create(ec2, cluster_id, type, security_group, args={})
        instance = find(ec2, cluster_id, type)
        return instance.nil? ? create(ec2, cluster_id, type, security_group, args) : instance
      end

      def create(ec2, id, type, security_group, args={})
        options = opts(type, security_group, args)
        instance = ec2.instances.create(options)
        tag(instance, id, type)
        return instance
      end

      def opts(type, security_group, args={})
        Scaler::Settings.aws.instances[type].merge(args).merge({
            security_groups: [security_group]
          }).to_hash(symbolize_keys: true)
      end
    end
  end
end
