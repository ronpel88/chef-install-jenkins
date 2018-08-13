# recipe that installs jenkins on ubuntu machine

# log a welcome message
log 'welcome_message' do
  message 'Hello Ron, the Creator of this amazing recipe!'
  level :info
end

# log another welcome message
log 'welcome_message2' do
  message 'going to install prerequisites & jenkins'
  level :info
end
  
# helper packages for development purposes
# nmap - gives info about network on a system
['nmap','wget','git', 'python-pip', 'groovy', 'ruby-full'].each do |p|
  package p do
    action :install
    ignore_failure true
  end
end

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

# install java
package "default-jre"

# get java path and save to variable
ruby_block "get_java_location" do
  block do
    s = shell_out("which java")
    node.default['java_location'] = s.stdout
  end
end

# add java path to general path
ruby_block 'set_java_path' do
  block do
    ENV['PATH'] = "#{ENV['PATH']}:#{node['java_location']}"
  end
end


execute 'set_JAVA_HOME' do
  command 'echo JAVA_HOME="`which java`" | tee -a /etc/environment'
end

# log path
ruby_block 'print_java_path' do
  block do
    puts "System Path is : #{ENV['PATH']}"
  end
end

# add jenkins repo to existing repositories and run update
apt_repository 'jenkins' do
  uri          'https://pkg.jenkins.io/debian-stable'
  distribution 'binary/'
  key          'https://pkg.jenkins.io/debian-stable/jenkins.io.key'
end

# install jenkins
package "jenkins"

# start jenkins service and enable the service to run at boot 
service "jenkins" do
  supports [:stop, :start, :restart]
  action [:start, :enable]
end
