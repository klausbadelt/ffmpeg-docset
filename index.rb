require_relative 'lib/ffmpeg_docset'

docset = FfmpegDocset.new('ffmpeg.docset')
Dir.glob("ffmpeg/doc/*.html").reject{ |p| p[/\-all.html/] }.each do |path|
  puts "Indexing #{File.basename(path)}"
  docset.add(path)
end
