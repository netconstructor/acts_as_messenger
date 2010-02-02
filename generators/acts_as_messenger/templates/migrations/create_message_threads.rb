class CreateMessageThreads < ActiveRecord::Migration
	
	def self.up
		create_table :message_threads do |t|
			t.integer :author_id
			t.string :title
			t.text :body
			t.boolean :private_thread, :default => true
			t.timestamps
		end
		
		add_index :message_threads, :author_id
	end
	
	def self.down
		drop_table :message_threads
	end
	
end