root = ::File.dirname(__FILE__)
logfile = ::File.join(root,'log','app.log')

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger = ::Logger.new(logfile,'weekly')

use Rack::CommonLogger, logger

err = File.open("log/error.log", "a+")
$stderr.reopen(err)
$stderr.sync = true

require ::File.join(root,'vk_photos')
set :environment, :production
enable :raise_errors, :dump_errors

run VkPhotos