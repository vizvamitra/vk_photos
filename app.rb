#!/usr/bin/env ruby

$:.unshift "#{Dir.pwd}/lib"

require 'sinatra'
require 'haml'
require 'zipruby'
require 'rufus-scheduler'
require 'securerandom'
require 'vk'

require './vk_photos'

if __FILE__ == $0
  VkPhotos.run! bind: '192.168.0.2', :port => 4000
end