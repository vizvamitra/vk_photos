require 'open-uri'
require 'json'

class VK

  attr_reader :app_id, :api_key
  attr_accessor :permissions, :redirect_uri

  def initialize app_id, api_key, permissions=[]
    @app_id = app_id
    @api_key = api_key
    @permissions = permissions
  end

  def auth_url
    "https://oauth.vk.com/authorize?" +
      "client_id=#{app_id}&" +
      "scope=#{permissions.join(',')}&" +
      "redirect_uri=#{redirect_uri}&" +
      "response_type=code&" +
      "v=5.21"
  end

  def token_url code
    "https://oauth.vk.com/access_token?" +
    "client_id=#{app_id}&" +
    "client_secret=#{api_key}&" +
    "code=#{code}&" +
    "redirect_uri=#{redirect_uri}"
  end

  def auth code
    JSON.parse(open(token_url code).read)
  end

  def get_photos_with token, uid
    uri = user_photos_uri token, uid
    photos = JSON.parse( open(uri).read )["response"]
    photos.shift
    photos.each{|photo| set_photo_url(photo)}
    photos
  end

  private

  def user_photos_uri token, uid
    'https://api.vk.com/method/photos.getUserPhotos?' +
    "user_id=#{uid}&" +
    "count=1000&" +
    "sort=0&" +
    "access_token=#{token}"
  end

  def set_photo_url photo
    url = photo["src_xxxbig"] || photo["src_xxbig"] || photo["src_xbig"] || photo["src_big"] || photo["src_small"] || photo["src"]
    photo["url"] = url
  end

end