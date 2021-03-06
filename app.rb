require 'rubygems'
require 'sinatra'

before do
  @upload_dir_name = 'uploads'
end

post '/upload' do
  Dir.mkdir(@upload_dir_name) unless Dir.exist?(@upload_dir_name)

  filename = params[:file][:filename]
  File.open(@upload_dir_name + '/' + filename, "w") do |f|
    f.write(params[:file][:tempfile].read)
  end
  return 'http://' + (ENV['HOST'] || 'localhost') + '/get/' + filename
end

get '/' do
  @files = Dir.entries(@upload_dir_name).reject { |f| f == '.' || f == '..' }

  @files_ctime = @files.map do |f|
    { name: f,
    ctime: File.ctime(@upload_dir_name + '/' + f) }
  end
  slim :index
end

get '/get/:filename' do |filename|
  filename.delete '/'
  if File.exist?(@upload_dir_name + '/' + filename)
    send_file @upload_dir_name + '/' + filename,
      filename: filename,
      type: 'Application/octet-stream'
  else
    status 404
  end
end
