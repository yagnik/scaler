module Scaler
  module Ec2
    class SecurityGroup
      attr_reader :master, :slave
      Rule = Struct.new(:key, :type, :port)

      def initialize(ec2, cluster_id)
        @master = find_or_create(ec2, cluster_id, "master")
        @slave = find_or_create(ec2, cluster_id, "slave")
      end

      def destroy
        @master.delete
        @slave.delete
      end

      private
      def find_or_create(ec2, cluster_id, type)
        instance = find(ec2, cluster_id, type)
        return instance.nil? ? create(ec2, cluster_id, type) : instance
      end

      def find(ec2, id, type)
        ec2.security_groups
          .tagged("scaler_type")
          .tagged_values(type)
          .tagged("scaler_id")
          .tagged_values(id).first
      end

      def create(ec2, cluster_id, type)
        group = ec2.security_groups.create("scaler:#{type}:#{cluster_id}")
        tag(group, type, cluster_id)
        authorize_ingress(group, rules(type))
        return group
      end

      def tag(security_group, type, id)
        security_group.tags["scaler_type"] = type
        security_group.tags["scaler_id"] = id
      end

      def rules(type)
        Scaler::Settings.aws.security_groups[type].ingress.map do |k,v|
          Rule.new(k,v["type"], v["port"])
        end
      end

      def authorize_ingress(security_group_instance, rules)
        rules.each do |rule|
          security_group_instance.authorize_ingress(rule.type, rule.port)
        end
      end
    end
  end
end
