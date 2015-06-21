require_relative 'lib/ffmpeg_docset'

docset = FfmpegDocset.new('_output/ffmpeg.docset')
Dir.glob(File.join(docset.path,"Contents/Resources/Documents/*.html")).each do |path|
  next if path =~ /\-all.html/
  puts "Indexing #{File.basename(path)}"
  docset.index(path)
end
