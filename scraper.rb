require 'json'
require 'fileutils'

def scrape_subject(subject, courses)
  lines = File.readlines(subject).each do |line|
    if line =~ /#{subject} [0-9]* - [^"]*(?="?<\/div>)/
      code, name = $~[0].split(" - ")
      puts "Uhoh, #{courses[code]} and #{name} conflict!" if courses.key?(code) && courses[code] != name
      courses[code] = name
    end
  end
end

def scrape
  courses = {}
  scrape_subject("CORE-UA", courses)
  scrape_subject("CHEM-UA",  courses)
  scrape_subject("CSCI-UA",  courses)
  scrape_subject("MATH-UA",  courses)
  scrape_subject("FREN-UA",  courses)
  scrape_subject("AHSEM-UA",  courses)
  courses
end

def write_json(courses)
  File.open("courses.json", 'w') { |file| file.write(JSON.generate(courses)) }
end

def write_js(courses)
  substitutions = []
  courses.each do |code, name|
    substitutions.push("{ regex: /#{code.gsub(" ", "(&nbsp;)")}/g, replacement: \"#{name}\" }")
  end
  File.open("chrome/courses.js", 'w') { |file| file.write(substitutions.join("\n")) }
end

courses = scrape
write_js(courses)
write_json(courses)

