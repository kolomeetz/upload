require 'rubygems'
require 'sinatra'

UPLOAD_DIR = 'uploads'

post '/upload' do
  filename = params[:file][:filename]
  mkdir UPLOAD_DIR unless Dir.exist?(UPLOAD_DIR)
  File.open(UPLOAD_DIR + '/' + filename, "w") do |f|
    f.write(params['file'][:tempfile].read)
  end
  return '/' + UPLOAD_DIR + '/' + filename
end

get '/' do
  slim :index
end
