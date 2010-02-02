class ActsAsMessengerGenerator < Rails::Generator::Base
	
	def manifest 
		record do |m|
			
			%w(comment message_thread recipient).each do |model|
				m.file "models/#{model}.rb", "app/models/#{model}.rb"
			end
			m.migration_template "migrations/acts_as_messenger_migration.rb", "db/migrate"
			
		end
	end
	
	def file_name
		"acts_as_messenger"
	end
end