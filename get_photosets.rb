require 'rubygems'
require 'flickraw'
require 'yaml'

###
### Retrieve user's photosets and save them in a YAML file to use in others scripts
###

APP_CONFIG = YAML.load_file("config.yml")['defaults']
FlickRaw.api_key = APP_CONFIG['api_key']
FlickRaw.shared_secret = APP_CONFIG['shared_secret']
flickr.access_token = APP_CONFIG['access_token']
flickr.access_secret = APP_CONFIG['access_secret']

# From here you are logged:
login = flickr.test.login
puts "You are now authenticated as #{login.username}"

photosets = flickr.call "flickr.photosets.getList"
sets = []
photosets.each{ |s|
  data = s.to_hash
  sets << data
}
File.open('photosets.yml', 'w') do |out|
  out.write(sets.to_yaml)
end
puts "photosets.yml saved."