require 'sinatra'
require 'haml'
require 'zip'
require 'rufus-scheduler'
require 'vk'

class VkPhotos < Sinatra::Base

  configure :development, :production do
    enable :logging
    enable :sessions
  end

  not_found { redirect '/' }

  before /auth|auth\/vk|download/ do
    @vk = VK.new(ENV['APP_ID'], ENV['APP_SECRET'])
    @vk.permissions = ["photos"]
    @vk.redirect_uri = "#{ENV['DOMAIN_NAME']}/auth/vk"
  end

  get('/') { haml :index }  

  get '/auth' do
    if session[:token] and session[:expires] > Time.now.to_i
      redirect '/download'
    else
      clear_session
      redirect @vk.auth_url
    end
  end

  get '/auth/vk' do
    if params[:code]
      response = @vk.auth(params[:code])

      if response["access_token"]
        set_session(response)
        redirect '/download'
      elsif response[:error]
        redirect "/error?msg=#{response["error_description"]}"
      end
    else
      redirect '/'
    end
  end

  get '/download' do
    photos = @vk.get_photos_with(session[:token], session[:uid])
    urls = photos.map{|photo| photo["url"]}
    filename = "#{session[:uid]}_#{Time.now.to_i}.zip"
    dir = "#{File.dirname(__FILE__)}/public/tmp/"
    info = zip_from_urls urls, dir+filename
    schedule_deletion(dir+filename)

    redirect "/photos?count=#{info[:count]}&skipped=#{info[:skipped]}&filename=#{'/tmp/'+filename}"
  end

  get '/photos' do
    @count = params[:count].to_i
    @skipped = params[:skipped].to_i
    @file_url = params[:filename]
    haml :photos
  end

  get '/error' do
    @msg = params[:msg]
    haml :error
  end

  private

  def zip_from_urls urls, filename
    count, skipped = 0, 0
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      urls.each do |url|
        name = url[/[^\/]+\.[\w]+$/]
        begin
          file = open(url)
          count += 1
        rescue
          skipped += 1
          next
        end
        zipfile.add(name, file)
      end
    end
    {count: count, skipped: skipped}
  end

  def schedule_deletion file
    Thread.new do
      filename = File.basename(file) 

      scheduler = Rufus::Scheduler.new
      scheduler.in '1h' do
        begin
          File.delete(file)
          logger.info("'#{filename}' successfully deleted")
        rescue => e
          logger.error("'#{filename}' deletion failed: e.message")
        end
      end

      logger.info "deletion scheduled for '#{filename}'"
    end if File.exist?(file)
  end

  def set_session response
    session[:token] = response["access_token"]
    session[:uid] = response["user_id"]
    session[:expires] = Time.now.to_i + response["expires_in"]
  end

  def clear_session
    session[:token] = nil
    session[:uid] = nil
    session[:expires] = nil
  end

end