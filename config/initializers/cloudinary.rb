Cloudinary.config do |config|
  config.cloud_name = ENV.fetch('CLOUDINARY_CLOUD_NAME', 'djuhjudsb')
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true
end
