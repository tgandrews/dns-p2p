require 'rubygems'
require 'optparse'
require 'eventmachine'
#require 'server'
require 'socket'
require 'net/dns/packet'
require 'net/dns/resolver'
require 'net/dns/question'

options = {}
optparse = OptionParser.new do |opts|
	options[:verbose] = false
	opts.on('-v', '--verbose', 'Enable verbose output') do
		options[:verbose] = true
	end

	options[:port] = 53
	opts.on('-p', '--port', 'The port to run the server on') do |val|
		options[:port] = val.to_i
	end

	options[:local_ip] = '0.0.0.0'
	opts.on('-l', '--local', 'The local IPv4 IP to run the server on, defaults to 0.0.0.0') do |val|
		options[:local_ip] = val.to_s
	end

	options[:dns_ip] = '8.8.8.8'
	opts.on('-d', '--dns', 'The IP location of the DNS server to forward all other requests, defaults to 8.8.8.8 (Google)') do |val|
		options[:dns_ip] = val.to_s
	end
end
optparse.parse!

if options[:verbose] = true then
	puts "Starting up..."
	puts "Binding to #{options[:local_ip]}:#{options[:port].to_s}"
end

module P2PDNS
	def post_init
		puts 'connected'
	end

	def receive_data(data)
		original_packet = Net::DNS::Packet::parse(data)
		p original_packet

		sock = UDPSocket.new
		sock.connect "8.8.8.8", 53
		sock.send data, 0
		ans = sock.recvfrom 1024
		sock.close

		response =  Net::DNS::Packet::parse(ans)
		p response
		return ans
	end

	def unbind
		puts 'disconnected'
	end
end


EM.run do
	EM.start_server options[:local_ip], options[:port], P2PDNS
	EM.open_datagram_socket options[:local_ip], options[:port], P2PDNS
end
