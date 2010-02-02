class Recipient < ActiveRecord::Base
	
	
	belongs_to :receiver, :polymorphic => true
  belongs_to :message_thread

  default_scope :order => 'has_read ASC, created_at DESC'

  named_scope :by_user, lambda {|u| {:conditions => ['receiver_type = ? and receiver_id = ?', 'User', u.id]}}
  named_scope :read, :conditions => ['has_read = ?', true]
  named_scope :unread, :conditions => ['has_read = ?', false]


	def read!
		self.update_attribute(:has_read, true)
	end
	
	def unread!
		self.update_attribute(:has_read, false)
	end
	
end