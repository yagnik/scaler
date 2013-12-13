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
      master: {
        image_id: "ami-ad184ac4",
        key: "<add your key here>"
        },
      slave: {
        image_id: "ami-ad184ac4",
        key: "<add your key here>"
      }
    },
    access_key: "<add your key here>",
    secret_access_key: "<add your key here>",
    region: "us-east-1"
  },
  cluster: {
    size: 5,
    process_count: 1,
    thread_count: 1
  },
  job: {
    interpreter: "ruby",
    file: nil,
    file_path: nil
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
    keep_releases: 3
  },
  chef: {
    json: {
      cookbook_path: [],
      runlist: ["recipe[beanstalkd]"]
    }
  }
}
