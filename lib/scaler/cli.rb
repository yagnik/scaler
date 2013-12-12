module Scaler
  class Cli < Thor

    desc "scale", "deploys current directory and execute provided class"
    method_option :cluster_id, :aliases => :i
    def scale
      puts "Now scaling"
      set_id(options[:cluster_id])
      Scaler::Launcher.new.run
    end

    desc "ready", "generates the required documents"
    def ready
      FileUtils.cp(Scaler.relative_path("templates/config.rb"), File.expand_path("."))
      FileUtils.mkdir_p("config/deploy")
      FileUtils.touch("config/deploy.rb")
      FileUtils.touch("config/deploy/scaler.rb")
    end

    desc "destroy", "DESTROY"
    method_option :cluster_id, :aliases => :i, :required => true
    def destroy
      set_id(options[:cluster_id])
      Scaler::Launcher.new.destroy
    end

    desc "download", "DESTROY"
    method_option :cluster_id, :aliases => :i, :required => true
    def download
      set_id(options[:cluster_id])
      Scaler::Launcher.new.download
    end

    private
    def set_id(id)
      Scaler::Settings.cluster.id = id if id
    end
  end
end

