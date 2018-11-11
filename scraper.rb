require 'json'

def scrape(filename, courses)
  lines = File.readlines(filename).each do |line|
    if line =~ /#{filename} [0-9]* - .*(?=<\/div>)/
      code, name = $~[0].split(" - ")
      puts "Uhoh, #{courses[code]} and #{name} conflict!" if courses.key?(code) && courses[code] != name
      courses[code] = name
    end
  end
end
courses = {}
scrape("CORE-UA", courses)
scrape("CHEM-UA",  courses)
scrape("CSCI-UA",  courses)

File.open("courses.json", 'w') { |file| file.write(JSON.generate(courses)) }
