require 'nokogiri'
require 'sqlite3'
# require 'fileutils'

class Docset
  attr_reader :path
    
  def initialize(path)
    @path = path
    @db = SQLite3::Database.new(File.join(@path, "/Contents/Resources/docSet.dsidx" ))
    @db.execute "CREATE TABLE IF NOT EXISTS searchIndex (id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
    @db.execute "CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);"
  end

  def index(path)
    @doc_basename = File.basename path
    @doc_html = Nokogiri::HTML File.read(path)
    @title = @doc_html.css('h1.settitle').first.content.sub(/\sDocumentation$/,'')
    index_node @title, 'Guide', '', @doc_basename
    index_anchors 'div.contents>ul.toc>li>a', 'Category'
    index_anchors 'div.contents>ul.toc>li>ul.toc>li>a', 'Section'
    # @todo: sections
  end
  
  private
  
  def index_anchors(selector,type)
    @doc_html
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
