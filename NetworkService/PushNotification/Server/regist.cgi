#!/opt/local/bin/ruby

require 'cgi'
require 'PNSDatabase'
require 'base64'

cgi = CGI.new

print cgi.header({
	"nph" => false,
	"status" => "OK",
	"type" => "text/html",
	"title" => "PNS"
})

def main(cgi)
	db = PNSDatabase.new("data.db")
	
	deviceToken = cgi.params['deviceToken'][0].unpack('m')[0]
	
	if cgi.params['action'][0] == 'regist'
		if db.isExist(deviceToken)
		else
			db.insert(deviceToken)
		end
		db.updateParam(deviceToken, cgi.params['param'][0])
	else cgi.params['action'][0] == 'unregist'
		db.remove(deviceToken)
	end
	db.close
end

main(cgi) if cgi.params['deviceToken'] && cgi.params['action'] && cgi.params['param']