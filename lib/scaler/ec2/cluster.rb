module Scaler
  module Ec2
    class Cluster
      attr_reader :id, :master, :slaves, :security_group
      def initialize
        @security_group = Scaler::Ec2::SecurityGroup.new(ec2, id)
        @master = create_instances(:master, 1).first
        @slaves = create_instances(:slave, Scaler::Settings.cluster.size)
        wait_all(:running)
        set_urls
      end

      def destroy
        instances.map(&:destroy)
        wait_all(:terminated)
        @security_group.destroy
      end

      private
      def create_instances(type, count)
        instances = []
        (1..count).each do |count|
          instances << Scaler::Ec2::Instance.new(ec2, id, type.to_s, @security_group.send(type))
        end
        instances
      end

      def set_urls
        Scaler::Settings.aws.instances.master.url = @master.url
        Scaler::Settings.aws.instances.slave.urls = @slaves.map{|s| s.url}
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
        if Scaler::Settings.cluster.id.nil?
          puts "SCALER ID: "
          @id = SecureRandom.uuid
          puts @id
          Scaler::Settings.cluster.id = @id
        else
          @id ||= Scaler::Settings.cluster.id
        end
      end
    end
  end
end
