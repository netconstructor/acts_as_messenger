class ActsAsMessengerGenerator < Rails::Generator::Base
	
	def manifest 
		record do |m|
			
			%w(comment message_thread recipient).each do |model|
				m.file "models/#{model}.rb", "app/models/#{model}.rb"
				m.migration_template "migrations/create_#{model.pluralize}.rb", "db/migrate"
			end
			
		end
	end
	
	def file_name
		"acts_as_messenger"
	end
end