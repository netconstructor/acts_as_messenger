class ActsAsMessengerGenerator < Rails::Generator::Base
	
	def manifest 
		record do |m|
			
			%w(comments message_threads recipients).each do |model|
				m.file "models/#{model}.rb", "app/models/#{model}.rb"
				m.migration_template "migrations/create_#{model}.rb", "db/migrate"
			end
			
		end
	end
	
	def file_name
		"acts_as_messenger"
	end
end