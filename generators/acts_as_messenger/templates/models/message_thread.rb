class MessageThread < ActiveRecord::Base
	include SocialButterfly::Thread
	
	acts_as_thread  
  has_many :recipients, :dependent => :destroy

	def recipient_by_user(u)
    self.recipients.by_user(u).first
  end
	
	
  def can_be_viewed_by?(user)
    !!(user && (!self.private_thread || self.author == user || self.recipient_objects.include?(user)))
  end

	protected 
	
		def recipient_objects
			self.recipients.find(:all, :include => :receiver).collect{|r| r.receiver}
		end
end