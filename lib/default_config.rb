DefaultConfig =
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
      master: {image_id: "ami-ad184ac4", key_name: nil},
      slave: {image_id: "ami-ad184ac4", key_name: nil}
    },
    access_key: nil,
    secret_access_key: nil,
    region: "us-east-1"
  },
  cluster: {
    size: 5,
    process_count: 2,
    thread_count: 2
  },
  job: {
    interpreter: "ruby",
    file: nil,
    file_path: nil
  },
  capistrano: {
    application: "scaler",
    repo_url: nil,
    deploy_to: "/Home/ubuntu/scaler",
    format: :pretty,
    log_level: :debug,
    stage: :scaler,
    ssh_options: { :forward_agent => true },
    use_sudo: true
  },
  chef: {
    cookbook_path: [],
    log_level: ":info",
    solo: true,
    json: {
      run_list: ["recipe[beanstalkd]"]
    }
  },
  internal: {
    local_tmp_dir: "/tmp",
    remote_tmp_dir: "/tmp/scaler",
    log_location: "/tmp/scaler/log",
    type_tag: "scaler_type",
    id_tag: "scaler_id",
    master_url: nil,
    id: nil
  }
}

DefaultConfig[:chef][:json_attribs] = "'#{DefaultConfig[:internal][:remote_tmp_dir]}/chef-solo/node.json'"
