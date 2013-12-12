#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install git ruby1.9.1
gem install beaneater
curl -L https://www.opscode.com/chef/install.sh | bash
