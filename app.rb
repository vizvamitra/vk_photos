#!/usr/bin/env ruby

require File.expand_path '../vk_photos.rb', __FILE__

if __FILE__ == $0
  VkPhotos.run! bind: ENV["BIND_IP"], :port => ENV['BIND_PORT']
end