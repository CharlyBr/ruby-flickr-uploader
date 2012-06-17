ruby-flickr-uploader
====================

Flickr uploader is a ruby script to automatically upload,sort and tag photos to Flickr.

## Prerequisites

* Ruby
* flickraw: https://github.com/hanklords/flickraw
* Yaml

## Tested on

* Mac OS X 10.7.3
* Ruby: ruby 1.9.1p431 (2011-02-18 revision 30908) [i386-darwin10.6.0]

## Getting started

### Flickr API Key

To run the script, you'll need an API key from your flickr account.
You can find and create your API keys associated with your account at http://www.flickr.com/services/api/keys/

When done, you'll need your *key* and *secret* to run the script.

### Configure Flickr Uploader

Copy *config.yml-dist* to *config.yml* and add your key (api_key parameter) and secret (shared_secret) parameter from flickr

Configuration file reference:
* api_key: flickr API key
* shared_secret: flickr shared secret
* access_token: flickr access token
* access_secret: flickr access secret 
* upload_path: where to find files to upload
* allowed_ext: filter files to upload by extension

### Authenticate the script with Flickr

run `ruby authenticate.rb` to get your *access_token* and *access_secret*


    $ ruby authenticate.rb
    Open this url in your process to complete the authication process : http://www.flickr.com/services/oauth/authorize?oauth_token=AAAAAAAAAAAAAAAAA-bbbbbbbbbbbb&perms=delete
    Copy here the number given when you complete the process.
    123-456-789
    You are now authenticated as Campeur with token CCCCCCCCCCCCCCCCC-ddddddddddddddddd and secret eeeeeeeeeeeeeeee
    $ _


You can now add token (access_token) and (access_secret) secret to your *config.yml* 

### Fetch your sets

Due to Flickr API limitation, I'm using a temporary yaml (*photosets.yml*) file to store your flickr sets. I use this file to query a set by its name.

    $ ruby get_photosets.rb 
    You are now authenticated as John
    photosets.yml saved.

### Upload process

The script works with a hierarchy of two folder levels.

    * APP_CONFIG['upload_path']
      - Album1
        - tag1
          - IMG_0001.jpg
      - Album2
        - tag2,tag3
          - IMG_0002.jpg
      ...

In this example, the script will upload:

* IMG_0001.jpg in album *Album1* with tag *tag1*

* IMG_0002.jpg in album *Album2* with tags *tag2* and *tag3*

Once a file is uploaded, it is *deleted* from the filesystem.


### Example

    $ ruby upload.rb 
    You are now authenticated as Campeur
    - will upload _MG_2070.jpg in album '2012 Oday' with tags ["Ilan"]
      found photoset with id: 72157629995407809
	    upload done.
	    file picture deleted.
	    adding picture to set 72157629995407809

## TODO

* add a Gemfile
* test on Ruby 1.8.x
* add support for movie files
* add pictures http://github.com/CharlyBr/ruby-flickr-uploader/raw/master/img/foo.png

## Licence

ruby-flickr-uploader is released under the MIT license:

* [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
