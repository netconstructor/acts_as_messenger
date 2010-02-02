module SocialButterfly
  module Thread
    
    def self.included(model)
      model.extend(SocialButterfly::Thread::ClassMethods)
      
      model.send(:include, SocialButterfly::Thread::InstanceMethods)
    end
    
    module ClassMethods
      def acts_as_thread
     
        validates_presence_of :author
        validates_inclusion_of :private_thread, :in => [true, false]

        belongs_to :author, :class_name => 'User'
        has_many :comments, :as => :commentable, :dependent => :destroy
        has_many :comment_participants, :through => :comments, :source => :author, :uniq => true
        
        named_scope :by_user, lambda {|user| user && {:conditions => ['author_id = ?', user.id]} || {}}
     
      end
    end
    
    module InstanceMethods
      def last_post
        self.comments.last || self
      end
      
      def participants
        (self.comment_participants + [self.author].compact).uniq
      end
  
    end
  end
end