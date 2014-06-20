#!/usr/bin/env ruby

$:.unshift "#{Dir.pwd}/lib"

require './vk_photos'

if __FILE__ == $0
  VkPhotos.run! bind: '192.168.0.2', :port => 4000
end