require_relative 'lib/docset'

docset = Docset.new('_output/ffmpeg.docset')
guides = 
Dir.glob(File.join(docset.path,"Contents/Resources/Documents/*.html")).each do |path|
  next if path =~ /\-all.html/
  puts "Indexing #{File.basename(path)}"
  docset.index(path)
end
