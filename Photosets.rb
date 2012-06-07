require 'rubygems'
require 'yaml'

class Photosets
  
  def initialize(name = 'photosets.yml')
    @data = YAML.load(File.open(name))
  end
  
  def get_set_by_title(title)
    @data.each{ |s|
      #puts "matching #{s['title']} and #{title}"
      return s if s["title"] == title
    }
    false
  end
  
  def show
    p @data
  end
end
