require_relative 'lib/ffmpeg_docset'

docset = FfmpegDocset.new('_output/ffmpeg.docset')
Dir.glob("_input/ffmpeg/doc/*.html").each do |path|
  next if path =~ /\-all.html/
  puts "Indexing #{File.basename(path)}"
  docset.add(path)
end
