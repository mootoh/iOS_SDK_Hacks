#!/home/son-son/local/bin/ruby

require 'rubygems'
require 'socket'
require 'openssl'
require 'json'

def json_obj(s)
	if s == "array"
		alert = {:body=>"text message"}
 		aps = {:alert=>alert}
		data = [10 ,1]
		json = {:aps=>aps,:data=>data}.to_json
		return json
	elsif s == "text"
		alert = {:body=>"text message"}
 		aps = {:alert=>alert}
		data = "This text data for PNS"
		json = {:aps=>aps,:data=>data}.to_json
		return json
	elsif s == "dict"
		alert = {:body=>"text message"}
 		aps = {:alert=>alert}
		data = {:title=>"hoge", :unread=>213}
		json = {:aps=>aps,:data=>data}.to_json
		return json
	elsif s == "badge"
 		aps = {:badge=>9}
		json = {:aps=>aps}.to_json
		return json
	elsif s == "sound"
 		aps = {:sound=>"default"}
		json = {:aps=>aps}.to_json
		return json
	elsif s == "sound2"
 		aps = {:sound=>"chime.caf"}
		json = {:aps=>aps}.to_json
		return json
	elsif s == "localize"
		alert = {:"action-loc-key"=>"READ", :"loc-key"=>"UNREAD_MESSAGE", :"loc-args"=>[4]}
 		aps = {:alert=>alert}
		json = {:aps=>aps}.to_json
		return json
	elsif s == "all"
 		aps = {:badge=>9}
		json = {:aps=>aps}.to_json
		return json
	else
 		aps = {:alert=>"This is PNS"}
		json = {:aps=>aps}.to_json
		return json
	end
end

def main
	json = json_obj(ARGV[0])
	puts json
	
	context = OpenSSL::SSL::SSLContext.new
	context.cert = OpenSSL::X509::Certificate.new(File.read("apns-dev.pem"))
	context.key = OpenSSL::PKey::RSA.new(File.read("apns-dev.pem"))
	
	@sock = TCPSocket.new("gateway.sandbox.push.apple.com", 2195)
	@ssl = OpenSSL::SSL::SSLSocket.new(@sock,context)
	@ssl.connect
	
	token = "c4c02c91 afd2de2d 4344f835 2222723a 9c176661 74907957 27b063ec 4ca47f69"
	key = [token.delete(' ')].pack('H*')
	
	puts "Payload size = #{json.size.to_s} byte"
	
	notification_packet = [0, 0, 32, key, 0, json.size, json].pack("ccca*cca*")
	@ssl.write(notification_packet)
	@ssl.close
	@sock.close
end

main()