#!/usr/bin/env ruby
# encoding: utf-8
$LOAD_PATH << './'

begin
  found_gem = Gem::Specification.find_by_name('flickraw')
rescue Gem::LoadError
  puts "Could not find gem 'flickraw', try 'bundle install'"
  exit
end

require 'rubygems'
require 'flickraw'
require 'Photosets'


##
## Upload script
##

# https://github.com/hanklords/flickraw
# http://www.flickr.com/services/api/
# http://www.flickr.com/services/api/upload.api.html

APP_CONFIG = YAML.load_file("config.yml")['defaults']

if APP_CONFIG['upload_path'].nil? or APP_CONFIG['upload_path'].empty? or !File.exists? APP_CONFIG['upload_path']
  puts "Your config upload_path is empty or doesn't exist."
  exit
end

FlickRaw.api_key = APP_CONFIG['api_key']
FlickRaw.shared_secret = APP_CONFIG['shared_secret']
flickr.access_token = APP_CONFIG['access_token']
flickr.access_secret = APP_CONFIG['access_secret']



# From here you are logged:
login = flickr.test.login
puts "You are now authenticated as #{login.username}"

all_sets = Photosets.new
Dir.glob("#{APP_CONFIG['upload_path']}/*").each do |album|
  next if album[0] == '.'
  album_filename = File.basename album
  #puts "album: #{album}"
  #puts "album filename: #{album_filename}"
  
  Dir.glob("#{album}/*").each do |tags|
    #puts "tags path: #{tags}"
    tags_filename = File.basename tags
    #puts "tags filename: #{tags_filename}"
    next if tags_filename[0] == '.'
    
    Dir.glob("#{tags}/*").each do |picture|

      picture_filename = File.basename picture
      if not APP_CONFIG['allowed_ext'].include? File.extname(picture_filename)
        puts "- #{File.extname(picture_filename)} are not allowed for upload, file was (#{picture_filename})"
        next
      end
      
      # exclude dotfiles
      next if picture_filename[0] == '.'

      puts "- will upload '#{picture_filename}' in album '#{album_filename}' with tags #{tags_filename.split(',')}"
      
      # Check if destination album exists
      photoset = all_sets.get_set_by_title(album_filename)
      if photoset == false
        puts "\t couldn't find any photoset named #{album_filename}, aborting..."
        next
      else
        puts "\t found photoset with id: #{photoset['id']}"
      end

      picture_path = "#{picture}".encode("UTF-8")
      encoded_tags = tags_filename.split(',').map{ |s| 
        s.encode("UTF-8")
        # add quotes for multiple words tags
        %Q/"#{s}"/ 
      }
      picture_id = flickr.upload_photo picture_path, :title => picture_filename, :description => "", 
                                            :tags =>encoded_tags.join(' '), :is_public => APP_CONFIG['is_public']
      if picture_id
        puts "\t upload done."
        File.unlink picture_path
        puts "\t file picture deleted."
        puts "\t adding picture to set #{photoset['id']}"
        res = flickr.call "flickr.photosets.addPhoto", {'photoset_id' => photoset['id'], 'photo_id' => picture_id}
      end
    end
  end
end