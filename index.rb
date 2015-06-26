require_relative 'lib/ffmpeg_docset'

docset = FfmpegDocset.new(File.join(ARGV[0],'ffmpeg.docset'))
Dir.glob(File.join(ARGV[0],"ffmpeg/doc/*.html")).reject{ |p| p[/\-all.html/] }.each do |path|
  puts "Indexing #{File.basename(path)}"
  docset.add(path)
end
