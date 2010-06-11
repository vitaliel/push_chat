require 'rubygems'
require 'em-http'

def subscribe(opts)
  listener = EventMachine::HttpRequest.new('http://127.0.0.5/activity?id='+ opts[:channel]).get :head => opts[:head]
  listener.callback {
    # print recieved message, re-subscribe to channel with
    # the last-modified header to avoid duplicate messages
    puts "Listener recieved: " + listener.response + "\n"

    modified = listener.response_header['LAST_MODIFIED']
    subscribe({:channel => opts[:channel], :head => {'If-Modified-Since' => modified}})
  }
end

EventMachine.run {
  channel = "pub"

  # Publish new message every 5 seconds
  EM.add_periodic_timer(5) do
    time = Time.now
    publisher = EventMachine::HttpRequest.new('http://127.0.0.5/publish?id='+channel).post :body => "Hello @ #{time}"
    publisher.callback {
      puts "Published message @ #{time}"
      puts "Response code: " + publisher.response_header.status.to_s
      puts "Headers: " + publisher.response_header.inspect
      puts "Body: \n" + publisher.response
      puts "\n"
    }
  end

  # open two listeners (aka broadcast/pubsub distribution)
  subscribe(:channel => channel)
  subscribe(:channel => channel)
}
