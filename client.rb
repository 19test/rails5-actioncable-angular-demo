require 'action_cable_client'

puts "Usage:\n"\
		 "1. klavyeden yaz + <ENTER>\n"\
		 "2. Web arayüzünden/client klasörü mesaj gönder\n\n"

module KeyboardHandler
	include EM::Protocols::LineText2
	
	def receive_line(data)
		message = {data: data, extra: 99}
		@client.perform('speak', message: message)
	end

	def client=(client)
		@client = client
	end
end

EventMachine.run do
	uri = "ws://localhost:3000/cable/"
	client = ActionCableClient.new(uri, 'ChatChannel')

	# the connected callback is required, as it triggers
	# the actual subscribing to the channel but it can just be
	# client.connected {}
	client.connected { puts 'successfully connected.' }

	# called whenever a message is received from the server
	client.received do | message |
		puts message
	end

	# adds to a queue that is purged upon receiving of
	# a ping from the server
	# client.perform('speak', { message: 'hello from amc' })
	EM.open_keyboard(KeyboardHandler){ |kb| kb.client = client }
end

