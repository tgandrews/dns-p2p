require 'rubygems'
require 'optparse'
require 'eventmachine'
require_relative 'ppdns'
require_relative 'options'

op = {}
optparse = OptionParser.new do |opts|
	op[:verbose] = false
	opts.on('-v', '--verbose', 'Enable verbose output') do
		op[:verbose] = true
	end

	op[:port] = 53
	opts.on('-p', '--port', 'The port to run the server on') do |val|
		op[:port] = val.to_i
	end

	op[:local_ip] = '0.0.0.0'
	opts.on('-l', '--local', 'The local IPv4 IP to run the server on, defaults to 0.0.0.0') do |val|
		op[:local_ip] = val.to_s
	end

	op[:dns_ip] = '8.8.8.8'
	opts.on('-d', '--dns', 'The IP location of the DNS server to forward all other requests, defaults to 8.8.8.8 (Google)') do |val|
		op[:dns_ip] = val.to_s
	end
end
optparse.parse!

options = Options.instance
options.load(op)

if options.verbose == true then
	puts "Starting up..."
	puts "Binding to #{op[:local_ip]}:#{op[:port].to_s}"
end



EM.run do
	# EM.start_server op[:local_ip], op[:port], P2PDNS
	EM.open_datagram_socket options.local_ip, options.port, P2PDNS
end
