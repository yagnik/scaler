module Scaler
  module Ec2
    class Instance
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

      def find(ec2, id, type)
        ec2.instances
          .tagged("scaler_type")
          .tagged_values(type)
          .tagged("scaler_id")
          .tagged_values(id).first
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

      def tag(instance, cluster_id, type)
        instance.tags["scaler_id"] = cluster_id
        instance.tags["scaler_type"] = type
      end
    end
  end
end
