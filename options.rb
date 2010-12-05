require 'singleton'

class Options
	include Singleton
	attr_accessor :dns_ip, :verbose, :local_ip, :port

	def load (options)
		@dns_ip = options[:dns_ip]
		@verbose = options[:verbose]

		@local_ip = options[:local_ip]
		@port = options[:port]
	end
end
