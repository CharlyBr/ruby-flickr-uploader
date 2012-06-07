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
FlickRaw.api_key = APP_CONFIG['api_key']
FlickRaw.shared_secret = APP_CONFIG['shared_secret']
flickr.access_token = APP_CONFIG['access_token']
flickr.access_secret = APP_CONFIG['access_secret']

# From here you are logged:
login = flickr.test.login
puts "You are now authenticated as #{login.username}"


#PHOTO_PATH='photo.jpg'
# You need to be authentified to do that, see the previous examples.

#f = Filer.new("/Users/charles/Desktop/Flickr/upload/AutoUpload")
all_sets = Photosets.new
BASE_PATH="/Users/charles/Desktop/Flickr/upload/AutoUpload"
Dir.glob("#{BASE_PATH}/*").each do |album|
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

      #puts "picture path #{picture}"
      picture_filename = File.basename picture
      #puts "picture filename #{picture_filename}"
      next if picture_filename[0] == '.'
      
      puts "- will upload #{picture_filename} in album '#{album_filename}' with tags #{tags_filename.split(',')}"
      
      # Check if destination album exists
      photoset = all_sets.get_set_by_title(album_filename)
      if photoset == false
        puts "\t couldn't find any photoset named #{album_filename}, aborting..."
        next
      else
        puts "\t found photoset with id: #{photoset['id']}"
      end

      picture_path = "#{picture}".encode("ASCII-8BIT")
      encoded_tags = tags_filename.split(',').map{ |s| 
        # encode because of UTF8-MAC bug
        s.encode("ASCII-8BIT")
        # add quotes for multiple words tags
        %Q/"#{s}"/ 
      }
      picture_id = flickr.upload_photo picture_path, :title => picture_filename, :description => "", 
                                            :tags =>encoded_tags.join(' '), :is_public => 0
      puts "\t upload done."
      File.unlink picture_path
      puts "\t file picture deleted."
      puts "\t adding picture to set #{photoset['id']}"
      res = flickr.call "flickr.photosets.addPhoto", {'photoset_id' => photoset['id'], 'photo_id' => picture_id}
    end
  end
end