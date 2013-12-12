OverwriteConfig =
{
  aws: {
    security_groups: {
      master: {
        ingress: {
          ssh: {type: "tcp", port: 22}
        }
      },
      slave: {
        ingress: {
          ssh: {type: "tcp", port: 22}
        }
      }
    },
    instances: {
      master: {image_id: "ami-ad184ac4", key: "<add your key here>"},
      slave: {image_id: "ami-ad184ac4", key: "<add your key here>"}
    },
    access_key: "<add your key here>",
    secret_access_key: "<add your key here>",
    region: "us-east-1"
  },
  cluster: {
    size: 5
  },
  job: {
    interpreter: "ruby"
  },
  capistrano: {
    application: "scaler",
    repo_url: 'git@github.com:example/repo.git',
    deploy_to: "/Home/ubuntu/scaler",
    format: :pretty,
    log_level: :error,
    pty: true,
    linked_files: [],
    linked_dirs: [],
    default_env: {},
    keep_releases: 3,
    use_sude: true,
    ssh_options: { :forward_agent => true },
  },
  chef: {
    log_level: :fatal,
    verbose_logging: false,
    json: {
      runlist: ["recipe[beanstalkd]"]
    }
  }
}
