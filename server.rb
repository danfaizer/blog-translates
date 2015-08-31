require 'sinatra'
require 'httparty'
require 'json'
require 'uri'

# languagecloud.sdl.com API endpoint & API Key
LC_API_KEY = "IQWaFsYsu%2FOR8kbGZyqhbA%3D%3D"
LC_API_URI = "https://lc-api.sdl.com"

# Languages available
AVAILABLE_LANGUAGES = { "English" => "eng", "Spanish" => "spa", "Swedish" => "swe", "German" => "ger", "French" => "fra" }

# Blog post API endpoint
BLOG_POST_URI = "http://localhost:8078/proxy/?vip=blog_posts&path=/posts"

# Get post
def get_post(post_id)
  begin
    response = HTTParty.get("#{BLOG_POST_URI}/#{post_id}")

    if response.code == 200
      return "#{JSON.parse(response.body)['content']}"
    elsif response.code == 404
      return "ERROR post does not exist #fail#"
    else
      raise "ERROR requesting Blog post #{post_id}"
    end
  rescue Exception => e
    raise "ERROR contacting Blog post API: #{e.message}"
  end
end

# Translate
def translate(from,to,text)
  begin
    response = HTTParty.post("#{LC_API_URI}/translate", 
    :body => { :text => "#{URI.escape(text)}", 
               :from => "#{from}", 
               :to => "#{to}"
             }.to_json,
    :headers => { 'Content-Type' => 'application/json',
                  "Authorization" => "LC apiKey=#{LC_API_KEY}" } )

    if response.code == 200
      return "#{JSON.parse(response.body)['translation']}"
    else
      raise "ERROR in translation request"
    end
  rescue Exception => e
    puts e.message
    raise "ERROR contacting translation API: #{e.message}"
  end
end

# Basic health check information about the application.
# No real test of the service capabilities at this point, a mere 200 response.
get '/healthcheck' do
  content_type 'application/json'
  status 200
  body '{ "healthcheck": "ok" }'
end

# A simple response for the Eureka interface links.
# A mere 200 response.
["/status", "/Status"].each do |path|
  get path do
    content_type 'application/json'
    status 200
    body '{ "status": "ok" }'
  end
end

# Enpoint that returns available languages
get '/translates/languages' do
  content_type 'application/json'
  status 200
  body "#{AVAILABLE_LANGUAGES.to_json}"
end

# Translates {post_id} text from English to {language}
get '/translates/:language/post/:post_id' do
  content_type 'application/json'
  begin
    post_id = params[:post_id]
    to_language = params[:language]

    # Obtain text to translate from blog-posts endpoint
    text_to_translate = get_post(post_id)

    # From language is hardcoded to English
    text_translated = translate('eng',to_language,text_to_translate)
    status 200
    body "{ \"content\" : #{text_translated.to_json} }"
  rescue Exception => e
    status 500
    body "{ \"content\" : \"#{e.message}\" }"
  end
end