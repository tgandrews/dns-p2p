require 'rubygems'
require 'eventmachine'
require 'net/dns/packet'
#require 'externaldns.rb'
require 'socket'

class P2PDNS < EventMachine::Connection
	def initalize(*args)
		super

		puts args[:server_ip].to_s
	end

	def post_init
		puts 'connected'
	end

	def receive_data(data)
		original_packet = Net::DNS::Packet::parse(data)
		puts 'Question:'
		p original_packet.question

		sock = UDPSocket.new
		sock.connect '8.8.8.8', 53
		sock.send data, 0
		answer = sock.recv 4096
		sock.close

		answer_parsed = Net::DNS::Packet::parse(answer)
		puts 'Answer:'
		p answer_parsed.answer

		send_data answer
	end

	def unbind
		puts 'disconnected'
	end
end
