require 'json'
require 'fileutils'
require_relative './renderer'

class Scraper < Object
  def scrape_subject(subject, courses)
    lines = File.readlines(subject).each do |line|
      if line =~ /#{subject} [0-9]* - [^"]*(?="?<\/div>)/
        code, name = $~[0].split(" - ")
        puts "Uhoh, #{courses[code]} and #{name} conflict!" if courses.key?(code) && courses[code] != name
        courses[code] = name
      end
    end
  end

  def scrape(subjects)
    courses = {}
    subjects.each do |subject|
      scrape_subject(subject, courses)
    end
    courses
  end
end
subjects = [
  "CORE-UA",
  "CHEM-UA", 
  "CSCI-UA", 
  "MATH-UA", 
  "FREN-UA", 
  "AHSEM-UA"
]

s = Scraper.new
courses = s.scrape(subjects)

renderer = Renderer.new
renderer.render(courses)

