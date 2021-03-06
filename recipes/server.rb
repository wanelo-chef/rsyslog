#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2012, Wanelo, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "rsyslog::default"

# Ensure that rsyslog only binds on correct interfaces
if node["rsyslog"]["udp"]["bind_attribute"]
  node.default["rsyslog"]["udp"]["bind_address"] = node[node["rsyslog"]["udp"]["bind_attribute"]]
else
  node.default["rsyslog"]["udp"]["bind_address"] = nil
end

if node["rsyslog"]["tcp"]["bind_attribute"]
  node.default["rsyslog"]["tcp"]["bind_address"] = node[node["rsyslog"]["tcp"]["bind_attribute"]]
else
  node.default["rsyslog"]["tcp"]["bind_address"] = nil
end

# Get data from data bags
custom_templates = data_bag_item("rsyslog", "templates")
custom_templates = custom_templates ? custom_templates["templates"] : []
logs = data_bag_item("rsyslog", "logs")
logs = logs ? logs["logs"] : []

# Ensure that directories and log files exist with correct mode
logs.each do |log|
  directory ::File.dirname(log["file"]) do
    recursive true
  end

  file log["file"] do
    owner log["owner"]
    mode log["mode"]
    action :create
    not_if { ::File.exists?(log["file"]) }
  end
end

# Configure rsyslog
template "/opt/local/etc/rsyslog.conf" do
  source "rsyslog.conf.erb"
  mode "0644"
  variables(
      "udp" => node["rsyslog"]["udp"],
      "tcp" => node["rsyslog"]["tcp"],
      "templates" => custom_templates,
      "logs" => logs
  )
  notifies :restart, "service[rsyslog]"
end
