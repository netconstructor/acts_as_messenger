class CreateComments < ActiveRecord::Migration
	
	def self.up
		create_table :comments do |t|
			t.references :commentable, :polymorphic => true
			t.integer :author_id
			t.text :body
			t.timestamps
		end
		
		add_index :comments, :author_id
		add_index :comments, [:commentable_id, :commentable_type]
	end
	
	def self.down
		drop_table :comments
	end
	
end