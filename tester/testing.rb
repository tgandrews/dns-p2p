require 'rubygems'
require 'socket'

host = '127.0.0.1'
port = '53'

puts host + ':' + port

puts 'Creating TCP connection'
conn = TCPSocket.open(host, port)

puts 'Sending TCP hello'
conn.puts 'TCP Hello'
conn.close

puts 'Creating UDP connection'
conn = UDPSocket.new
conn.connect(host, port)

puts 'Sending UDP hello'
conn.send 'UDP Hello', 0
