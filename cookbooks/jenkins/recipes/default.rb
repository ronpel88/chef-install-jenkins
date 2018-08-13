# recipe that installs jenkins

# install java
package "default-jre"

# add java location to path
ruby_block 'set_java_path' do
  block do
    ENV['PATH'] = "#{ENV['PATH']}:/usr/bin/java"
  end
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