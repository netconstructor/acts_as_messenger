require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActsAsMessenger" do
	
	before(:each) do 
		@mike = User.create(:name => 'Mike')
		@john = User.create(:name => 'John')
		@sky = User.create(:name => 'Sky')
	end
	
  it "Should integrate flawlessly" do
		@mike.methods.include?('send_message').should be_true
		m = @mike.method('send_message')
		m.arity.should eql(3)
  end

	it "Should generate a valid thread" do
		thread = @mike.send_message('Title', 'Body', @john)
		thread.valid?.should be_true
	end
	
	it "Should generate recipients correctly" do
		thread = @mike.send_message('Title 1', 'Body 1', @john)
		
		thread.recipients.size.should eql(1)
		@john.recipients.size.should eql(1)
		@mike.recipients.size.should eql(0)
		
		thread = @john.send_message('Title 2', 'Body 2', [@mike.id, @sky.id])
		
		thread.recipients.size.should eql(2)
	
		@mike.reload
		@john.reload
		@sky.reload
		
		@mike.recipients.size.should eql(1)
		@john.recipients.size.should eql(1)
		@sky.recipients.size.should eql(1)
		
	end
	
	it "Should allow for removal of recipient from thread" do
		thread = @mike.send_message('Title 3', 'Body 3', [@john, @sky])
		
		@john.recipients.first.read!
		@john.recipients.read.size.should eql(1)
		@john.recipients.unread.size.should eql(0)
		
		@sky.comment_on(thread, 'This is totally awesome')
		
		@john.recipients.unread.size.should eql(1)
		@john.recipients.read.size.should eql(0)
		
		@john.recipients.first.destroy
		
		@sky.comment_on(thread, 'Seriously, i love this')
		
		@john.recipients.size.should eql(0)
		
	end
	
	it "Should allow destroy all recipients on thread destruction" do
		thread = @mike.send_message('Title 4', 'Body 4', [@john, @sky, @john, @sky])
		
		@john.recipients.size.should eql(1)
		
		thread.destroy
		
		@john.recipients.size.should eql(0)
		@sky.recipients.size.should eql(0)
		
	end
	
	it "Should access participants properly" do
		thread = @mike.send_message('Title 5', 'Body 5', [@john, @sky])
		
		thread.participants.sort{|a,b| a.id <=> b.id}.should eql([@mike])
		
		@john.comment_on(thread, 'Test')
		
		thread.reload
		thread.participants.sort{|a,b| a.id <=> b.id}.should eql([@mike, @john])
		
		@sky.comment_on(thread, 'Tester')
		
		thread.reload
		thread.participants.sort{|a,b| a.id <=> b.id}.should eql([@mike, @john, @sky])
	end
	
	it "Should restrict access to the right objects" do
		thread = @mike.send_message('Title 6', 'Body 6', [@john, @sky])
		
		frank = User.create
		thread.can_be_viewed_by?(frank).should be_false
		
		thread.can_be_viewed_by?(@sky).should be_true
		
	end
	
end
