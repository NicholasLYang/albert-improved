require 'erb'

class Renderer
  attr_reader :substitutions
  
  def generate_substitutions(courses)
    substitutions = []
    courses.each do |code, name|
      substitutions.push("{ regex: /#{code.gsub(" ", "(&nbsp;| )*")}(?=(&nbsp;|  |-|<))/g, replacement: \"#{name} -- #{code} \" }")
    end

    @substitutions = substitutions.join(",\n")
  end

  def render_link(url, content)
    "\"<a href=#{url} target=\\\"_blank\\\"> #{content} </a>\""
  end
  
  def render(courses)
    generate_substitutions(courses)
    template = File.open("chrome/index.js.erb", 'rb', &:read)
    res = ERB.new(template).result(binding)
    File.open("chrome/index.js", 'w') { |file| file.write(res) }
  end
end
