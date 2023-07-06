require 'cloudinary'
require 'dotenv/load'

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
end

base_folder_path = 'app/assets/images'
subdirectories = ['backgrounds', 'brand', 'dashboards', 'events', 'users']

subdirectories.each do |subdir|
  folder_path = File.join(base_folder_path, subdir)
  Dir.foreach(folder_path) do |file_name|
    next if file_name == '.' || file_name == '..'
    file_path = File.join(folder_path, file_name)
    if File.file?(file_path)
      response = Cloudinary::Uploader.upload(file_path)
      puts "Uploaded #{file_name} to Cloudinary: #{response['secure_url']}"
    end
  end
end
