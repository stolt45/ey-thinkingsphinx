require 'pp'
#
# Cookbook Name:: thinking_sphinx
# Recipe:: default
#
#if_app_needs_recipe("thinking_sphinx") do |app,data,index|

node[:applications].each do |app_name,data|
#  next unless app == 'climate_culture_app'
  user = node[:users].first

  directory "/var/run/sphinx" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/sphinx/#{app}" do
    recursive true
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end
  
  remote_file "/etc/logrotate.d/sphinx" do
    owner "root"
    group "root"
    mode 0755
    source "sphinx.logrotate"
    action :create
  end

  template "/etc/monit.d/sphinx.#{app}.monitrc" do
      source "sphinx.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :app_name => app_name
      })
  end

  template "/data/#{app}/shared/config/sphinx.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sphinx.yml.erb"
    variables({
      :app_name => app_name
      :user => user
    })
  end
  
  link "/data/#{app_name}/current/config/sphinx.yml" do
    to "/data/#{app_name}/shared/config/sphinx.yml"
  end

  link "/data/#{app_name}/current/config/thinkingsphinx" do
    to "/data/#{app_name}/shared/config/thinkingsphinx"
  end

end
