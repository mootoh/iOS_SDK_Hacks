#!/home/son-son/local/bin/ruby

require 'cgi'
require 'rubygems'
require 'socket'
require 'openssl'
require 'json'
require 'PNSDatabase'

def main
	# Databaseを開き，現在時をparamに持つdeviceTokenのリストを取得
	db = PNSDatabase.new("data.db")
	t = Time.now.hour
	tokenList = db.tokenListOf(t)
	
	# SSL通信のソケットを初期化
	context = OpenSSL::SSL::SSLContext.new
	context.cert = OpenSSL::X509::Certificate.new(File.read("../Simple/apns-dev.pem"))
	context.key = OpenSSL::PKey::RSA.new(File.read("../Simple/apns-dev.pem"))
	
	# ソケットを接続
	sock = TCPSocket.new("gateway.sandbox.push.apple.com", 2195)
	ssl = OpenSSL::SSL::SSLSocket.new(sock,context)
	ssl.connect
	
	# JSONオブジェクトを作成
	alert = {:"action-loc-key"=>"READ", :"loc-key"=>"UNREAD_MESSAGE", :"loc-args"=>[4]}
 	aps = {:alert=>alert, :sound=>"chime.caf"}
	json = {:aps=>aps}.to_json
	
	# deviceTokenリストに含まれるdeviceTokenを宛先に，JSONオブジェクトを送る
	tokenList.each{|token|
		key = [token.delete(' ')].pack('H*')
		notification_packet = [0, 0, 32, key, 0, json.size, json].pack("ccca*cca*")
		ssl.write(notification_packet)
	}

	# ソケットを切断して閉じる
	ssl.close
	sock.close
end

main()