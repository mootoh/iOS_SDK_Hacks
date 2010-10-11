require 'sqlite3'

class PNSDatabase < SQLite3::Database

	def initialize(filepath)
		isAlreadyExist = File.file?(filepath)
		super(filepath)
		if (!isAlreadyExist)
			sql = "create table id_table (id INTEGER PRIMARY KEY AUTOINCREMENT, deviceToken varchar(200), param INTEGER);"
			begin
				self.execute(sql)
			rescue => exc
				puts exc
			else
			end
		end
	end
	
	#
	# 指定したdeviceTokenがすでに登録されているかを確認する
	#
	def isExist(deviceToken)
		begin
			result = self.get_first_row('select * from id_table where deviceToken = ?', deviceToken)
		rescue => e
			puts e
		else
			(result != nil)
		end
	end
	
	#
	# 指定したdeviceTokenを登録する
	#
	def insert(deviceToken)
		begin
			self.execute('insert into id_table values (NULL, ?, 0)', deviceToken)
		rescue => e
			puts e
		else
		end
	end
	
	#
	# 指定したdeviceTokenのparamの値を更新する
	#
	def updateParam(deviceToken, param)
		begin
			self.execute('update id_table set param = ? where deviceToken = ?', param, deviceToken)
		rescue => e
			puts e
		else
		end
	end
	
	#
	# 指定したdeviceTokenを持つレコードを削除する
	#
	def remove(deviceToken)
		begin
			self.execute('delete from id_table where deviceToken = ?', deviceToken)
		rescue => e
			puts e
		else
		end
	end
	
	#
	# 指定した値とparamが等しいレコードが含むdeviceTokenをリストで返す
	#
	def tokenListOf(param)
		tokenList = Array.new
		result = self.execute('select deviceToken from id_table where param = ?', param)
		result.each do |row|
			tokenList.push(row[0])
		end
		tokenList
	end

end