require 'rubygems'
require 'eventmachine'
require 'net/dns/packet'
require 'socket'
require_relative 'options'

class P2PDNS < EventMachine::Connection
	def post_init
		@options = Options.instance
		if @options.verbose == true
			puts 'connected'
		end
	end

	def receive_data(data)
		original_packet = Net::DNS::Packet::parse(data)
		if @options.verbose == true
			puts 'Question:'
			p original_packet.question
		end

		sock = UDPSocket.open
		sock.do_not_reverse_lookup = true
		sock.connect @options.dns_ip, 53
		sock.send data, 0
		answer = sock.recv 4096

		answer_parsed = Net::DNS::Packet::parse(answer)
		if @options.verbose == true
			puts 'Answer:'
			p answer_parsed.answer
		end

		send_data answer
	end

	def unbind
		if @options.verbose == true
			puts 'disconnected'
		end
	end
end
