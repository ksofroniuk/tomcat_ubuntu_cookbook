#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# sudo apt-get update 
# sudo apt-get install default-jdk
package 'default-jdk'

# sudo groupadd tomcat
group 'tomcat'

# sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
user 'tomcat' do
  manage_home false
  shell '/bin/false'
  group 'tomcat'
  home '/opt/tomcat'
end

# wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.33/bin/apache-tomcat-8.5.33.tar.gz
remote_file 'apache-tomcat-8.5.33.tar.gz' do
  source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.33/bin/apache-tomcat-8.5.33.tar.gz'
end

directory '/opt/tomcat' do
  # action :create
end

# TODO: NOT DESIRED STATE
execute 'tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

# TODO: NOT DESIRED STATE
execute 'chgrp -R tomcat /opt/tomcat'
execute 'chmod -R g+r /opt/tomcat/conf'

directory '/opt/tomcat/conf' do
  mode '0010'
end

# TODO: NOT DESIRED STATE
execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

# TODO: NOT DESIRED STATE
execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end

# TODO: NOT DESIRED STATE
execute 'ufw allow 8080'
