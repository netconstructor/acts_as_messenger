module SocialButterfly
  module Message
    def self.included(model)
      model.extend(SocialButterfly::Message::ClassMethods)
      model.send(:include, SocialButterfly::Message::InstanceMethods)
    end
    
    module ClassMethods
      def acts_as_messenger
          has_many :recipients, :as => :receiver, :include => {:message_thread => :comments}
          has_many :unread_recipients, :source => :recipients, :class_name => 'Recipient', :as => :receiver, :conditions => {:read => false}
          has_many :read_recipients, :source => :recipients, :class_name => 'Recipient', :as => :receiver, :conditions => {:read => true}

          has_many :sent_messages, :class_name => 'MessageThread', :foreign_key => :author_id
          has_many :unread_messages, :through => :unread_recipients, :source => :message_thread
          has_many :read_messages, :through => :read_recipients, :source => :message_thread
      end
    end
    
    module InstanceMethods
      def send_message(title, body, recips)
        thread = ::MessageThread.create(:author => self, :title => title, :body => body, :private_thread => true)
        thread.recipients = [recips].flatten.uniq.collect{|recip| rdata = recipient_data(recip); thread.recipients.create(:receiver_id => rdata[0], :receiver_type => rdata[1])}
        thread
      end
      def recipient_for(message)
        self.recipients.find(:first, :conditions => ['message_thread_id = ?', message.id])
      end
      
      def comment_on(message, body)
        if message && body
          message.comments.create(:author => self, :body => body)
          recip = recipient_for(message)
          (message.recipients - [recip].compact).each{|recipient| recipient.unread!}
          true
        else
          false
        end
      end

			private 
			
				def recipient_data(given)
					given.is_a?(Fixnum) && [given, self.class.name] || [given.id, given.class.name]
				end
    end
  end
end

::ActiveRecord::Base.send :include, SocialButterfly::Message