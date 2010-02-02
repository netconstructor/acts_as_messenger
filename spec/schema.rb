ActiveRecord::Schema.define :version => 0 do
  
	create_table :comments, :force => true do |t|
		t.references :commentable, :polymorphic => true
		t.integer :author_id
		t.text :body
		t.timestamps
	end

	create_table :message_threads, :force => true do |t|
		t.integer :author_id
		t.string :title
		t.text :body
		t.boolean :private_thread, :default => true
		t.timestamps
	end
	
	create_table :recipients, :force => true do |t|
		t.references :receiver, :polymorphic => true
		t.references :message_thread
		t.boolean :has_read
		t.timestamps
	end
	
	create_table :users, :force => true do |t|
		t.string :name
		t.timestamps
	end
end