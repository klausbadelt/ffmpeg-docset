require 'nokogiri'
require 'sqlite3'
# require 'fileutils'

class FfmpegDocset
  attr_reader :path
    
  def initialize(path)
    @path = path
    @db = SQLite3::Database.new(File.join(@path, "/Contents/Resources/docSet.dsidx" ))
    @db.execute "CREATE TABLE IF NOT EXISTS searchIndex (id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
    @db.execute "CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);"
  end

  def add(input_path)
    @input_path = input_path
    @doc_basename = File.basename @input_path
    @doc = Nokogiri::HTML File.read(@input_path)
    @title = @doc.css('h1.settitle').first.content.sub(/\sDocumentation$/,'')
    @doc.css('head title').first.content = @title
    index_node @title, doc_type, '', @doc_basename
    index_anchors 'div.contents>ul.toc>li>a', 'Section'
    index_anchors 'div.contents>ul.toc>li>ul.toc>li>a', 'Entry'
    create_toc
    write_html
  end
  
  private
  
  def doc_type
    if @doc_basename =~ /^ffmpeg-/
      'Component'
    elsif @doc_basename =~ /^ff[a-z]+\.html/
      'Command'
    elsif @doc_basename =~ /^lib/
      'Library'
    else
      'Guide'
    end
  end
  
  def index_anchors(selector,type)
    @doc
    .css(selector)
    .reject { |n| /^\d+\.(\d+)?\s+Authors|Description|See Also/ =~ n.content }
    .each do |n|
      index_node "#{dechapterize(n.content)} – #{@title}", type, n[:href], @doc_basename
    end
  end

  def index_node(name, type, path, doc_basename)
    @db.execute "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?);", [name, type, "#{doc_basename}#{path}"]
  end
    
  def dechapterize(name)
    "#{name.sub(/^\d+\.(\d+)?\s+/, '')}"
  end
  
  def create_toc
    entry_type = 'Section'
    @doc.css('h1.chapter').each do |chap|
      a = @doc.create_element 'a'
      entry_name = dechapterize(chap.content)
      a['name'] = "//apple_ref/cpp/#{entry_type}/#{entry_name}"
      a['class'] = 'dashAnchor'
      chap.previous = a
      puts "  Adding chapter #{entry_name}"
    end
    entry_type = 'Entry'
    @doc.css('h2.section').each do |chap|
      a = @doc.create_element 'a'
      entry_name = dechapterize(chap.content)
      a['name'] = "//apple_ref/cpp/#{entry_type}/#{entry_name}"
      a['class'] = 'dashAnchor'
      chap.previous = a
      puts "  Adding section #{entry_name}"
    end
    
  end
  
  def write_html
    File.open(File.join(@path,'/Contents/Resources/Documents',@doc_basename), 'w') {|f| f.write(@doc.to_html) }
  end
    
    
    
end
  
# def write_html(doc, file)
#   builder = Nokogiri::HTML::Builder.new do |b|
#     b.html do
#       b.header { b << doc.title}
#       b.body do b << doc.css("#content").first end
#     end
#   end
#   File.open("_output/erlang.docset/Contents/Resources/Documents/#{file}", 'w') {|f| f.write(builder.to_html) }
# end
#
