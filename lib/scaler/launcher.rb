require 'capistrano/all'
require 'capistrano/setup'
require 'capistrano/deploy'
Dir.glob(Scaler.relative_path('capistrano/tasks/*.cap')).each { |r| load r }

module Scaler
  class Launcher
    include Capistrano::DSL

    def run
      cluster = Scaler::Ec2::Cluster.new
      sleep 45
      Capistrano::Application.invoke("scaler")
      build_cap(cluster)
      Capistrano::Application.invoke("deploy")
    end

    def destroy
      cluster = Scaler::Ec2::Cluster.new
      download(cluster)
      cluster.destroy
    end

    def download(cluster=nil)
      cluster ||= Scaler::Ec2::Cluster.new
      Capistrano::Application.invoke("scaler")
      build_cap(cluster)
      Capistrano::Application.invoke("slave:download")
    end

    private
    def build_cap(cluster)
      Scaler::Settings.capistrano.each do |k,v|
        if v.kind_of? Hash
          value = {}
          v.each { |vk, vv| value[vk.to_sym] = vv }
          set k.to_sym, value
        else
          set  k.to_sym, v
        end
      end
      set :ssh_options, { forward_agent: true }
      role :master, [cluster.master.url]
      role :slave, cluster.slaves.map { |slave| slave.url }
      Scaler::Settings.internal.master_url = cluster.master.url
      # role :master, %w{ec2-54-205-33-107.compute-1.amazonaws.com}
      # role :slave, %w{ec2-50-17-69-165.compute-1.amazonaws.com}
    end
  end
end
