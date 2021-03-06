package 'unzip'

include_recipe 'apt'
include_recipe 'java'

ark 'jetty' do
  url 'http://dist.codehaus.org/jetty/jetty-6.1.x/jetty-6.1.3.zip'
end

ark 'play' do
  url 'http://downloads.typesafe.com/play/2.1.3/play-2.1.3.zip'
end

#normally, we would fetch a dist zipped from somewhere
#and unzip it. To test we're just building a sample project
#from play directory
helloworld_dir = "/usr/local/play/samples/scala/helloworld"
bash "create play project" do
  cwd "#{helloworld_dir}"
  code "/usr/local/play/play stage"
end

java_wrapper 'jetty' do
  app_parameters ["org.mortbay.start.Main"]
  classpath ["/usr/local/jetty/start.jar"]
  java_parameters ["-Djetty.home=/usr/local/jetty"]
end

java_wrapper 'play' do
  classpath ["#{helloworld_dir}/target/staged/*"]
  app_parameters ["play.core.server.NettyServer", "#{helloworld_dir}"]
  java_parameters ["-Dhttp.port=9001"]
end
