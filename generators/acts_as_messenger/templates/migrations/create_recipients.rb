class CreateRecipients < ActiveRecord::Migration
	
	def self.up
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
		
	end
	
end