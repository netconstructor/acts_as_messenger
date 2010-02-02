$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'active_record'
require 'acts_as_messenger'
require 'spec'
require 'spec/autorun'
require 'models/user.rb'
require File.dirname(__FILE__) + "/../lib/acts_as_messenger/thread"
%w(comment message_thread recipient).each do |model|
	require File.dirname(__FILE__) + "/../generators/acts_as_messenger/templates/models/#{model}.rb"
end

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')
 
load(File.dirname(__FILE__) + '/schema.rb')


Spec::Runner.configure do |config|
  
end
