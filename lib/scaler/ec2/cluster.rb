module Scaler
  module Ec2
    class Cluster
      attr_reader :id, :master, :slaves, :security_group
      def initialize
        @security_group = Scaler::Ec2::SecurityGroup.new(ec2, id)
        @master = create_instances("master", 1).first
        @slaves = create_instances("slave", Scaler::Settings.cluster.size)
        wait_all(:running)
      end

      def destroy
        instances.map(&:destroy)
        wait_all(:terminated)
        @security_group.destroy
      end

      private
      def create_instances(type, count)
        (1..count).map do |c|
          Scaler::Ec2::Instance.new(ec2, id, type.to_s, @security_group.send(type))
        end
      end

      def wait_all(status)
        instances.each {|i| i.wait(status)}
      end

      def instances
        [@master] + @slaves
      end

      def ec2
        @ec2 ||= AWS::EC2.new({
          access_key_id: Scaler::Settings.aws.access_key,
          secret_access_key: Scaler::Settings.aws.secret_access_key,
          region: Scaler::Settings.aws.region})
      end

      def id
        if Scaler::Settings.internal.cluster_id.nil?
          puts "SCALER ID: "
          @id = SecureRandom.uuid
          puts @id
          Scaler::Settings.internal.cluster_id = @id
        else
          @id ||= Scaler::Settings.internal.cluster_id
        end
      end
    end
  end
end
