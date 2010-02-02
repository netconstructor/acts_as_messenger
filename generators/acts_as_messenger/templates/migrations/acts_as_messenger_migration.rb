class ActsAsMessengerMigration < ActiveRecord::Migration
	
	def self.up
		create_table :comments do |t|
			t.references :commentable, :polymorphic => true
			t.integer :author_id
			t.text :body
			t.timestamps
		end
		
		add_index :comments, :author_id
		add_index :comments, [:commentable_id, :commentable_type]
		
		create_table :message_threads do |t|
			t.integer :author_id
			t.string :title
			t.text :body
			t.boolean :private_thread, :default => true
			t.timestamps
		end
		
		add_index :message_threads, :author_id
		
		create_table :recipients do |t|
			t.references :receiver, :polymorphic => true
			t.references :message_thread
			t.boolean :has_read
			t.timestamps
		end
		
		add_index :recipients, :message_thread_id
		add_index :recipients, [:receiver_id, :receiver_type]
		
	end
	
	def self.down
		
		drop_table :recipients
		drop_table :message_threads
		drop_table :comments
		
	end
	
end