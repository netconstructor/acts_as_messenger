class Comment < ActiveRecord::Base
	
	default_scope :order => 'created_at asc'
	
	belongs_to :author, :class_name => 'User'
  belongs_to :commentable, :polymorphic => true

end
