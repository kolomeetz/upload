require 'rubygems'
require 'sinatra'

post '/upload' do
  upload_dir_name = 'uploads'
  Dir.mkdir(upload_dir_name) unless Dir.exist?(upload_dir_name)

  filename = params[:file][:filename]
  File.open(upload_dir_name + '/' + filename, "w") do |f|
    f.write(params[:file][:tempfile].read)
  end

  return '/' + upload_dir_name + '/' + filename
end

get '/' do
  slim :index
end
