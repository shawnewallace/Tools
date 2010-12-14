require 'date'
require 'fileutils'

def next_weekday(original_date)
				one_day = 60 * 60 * 24
				weekdays = 1..5
				result = original_date
				result += one_day until result > original_date && weekdays.member?(result.wday)
				result
end

def archive_files(path, filesOlderThan)
	puts "Will archive files older than " + filesOlderThan.to_s

	Dir.foreach(path) do |fname|
				next if fname == '.' or fname == '..' or fname == 'Archive'

				year = fname[0..3]
				month = fname[4..5]
				day = fname[6..7]

				puts fname

				fileDate =  Time.utc(year, month, day)

				puts "I WILL ARCHIVE" if fileDate <= filesOlderThan
				puts "I WILL NOT ARCHIVE" if fileDate > filesOlderThan

				FileUtils.mv path + "\\" + fname, path + "\\Archive" if fileDate <= filesOlderThan
	end					
end

def generate_new_log_files(path, numFilesToGenerate)
				today = Time.now

	numFilesToGenerate.times do
				today = next_weekday(today)
				fileName = path + "\\" + today.strftime("%Y%m%d Workday - %a.txt")
				doc = " "
				File.open(fileName, 'w') {|f| f.write(doc)} if not File.exists?(fileName)
	end
end

a_day = 60 * 60 * 24
numberOfDaysToGenerate = 10

path = ARGV[0]
numFilesToGenerate = ARGV[1].to_i

puts path
generate_new_log_files(path, numFilesToGenerate)

tenDaysAgo = Time.now - ( a_day * numberOfDaysToGenerate)
archive_files(path, tenDaysAgo)

