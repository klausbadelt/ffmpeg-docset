require 'sqlite3'
require 'uri'
require 'nokogiri'

class FfmpegDoc
  def initialize(path, docset)
    @path = path
    @docset = docset
    @basename = File.basename @path
    @html = Nokogiri::HTML File.read(@path)
  end

  def index
    @html.css('head title').first.content = title
    index_insert title, type, ''
    index_anchors 'div.contents>ul.toc>li>a', with_type: 'Section'
    index_anchors 'div.contents>ul.toc>li>ul.toc>li>a', with_type: 'Entry'
    create_toc
  end

  def write
    File.open(File.join(@docset.path,'/Contents/Resources/Documents',@basename), 'w') {|f| f.write(@html.to_html) }
  end

  def type
    if @basename =~ /^ffmpeg-/
      'Component'
    elsif @basename =~ /^ff[a-z]+\.html/
      'Command'
    elsif @basename =~ /^lib/
      'Library'
    else
      'Guide'
    end
  end

  def title
    @title ||= @html.css('h1.settitle').first.content.sub(/\sDocumentation$/,'')
  end

  private

  def index_anchors(selector, with_type:)
    @html
    .css(selector)
    .reject { |n| /^\d+\.(\d+)?\s+Authors|Description|See Also/ =~ n.content }
    .each do |n|
      index_insert "#{dechapterize(n.content)} – #{title}", with_type, n[:href]
    end
  end

  def index_insert(name, type, path)
    @docset.db.execute "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?);", [name, type, "#{@basename}#{path}"]
  end

  # removes chapter numbering like '5.1 Title of Chapter' -> 'Title of Chapter'
  def dechapterize(name)
    "#{name.sub(/^\d+\.(\d+)?\s+/, '')}"
  end

  def create_toc
    create_toc_anchors_for 'h1.chapter', with_type: 'Section'
    create_toc_anchors_for 'h2.section', with_type: 'Entry'
  end

  def create_toc_anchors_for(selector, with_type: 'Section')
    @html.css(selector).each do |chap|
      a = @html.create_element 'a'
      entry_name = dechapterize(chap.content)
      a['name'] = "//apple_ref/cpp/#{with_type}/#{URI::escape(entry_name, URI::PATTERN::UNRESERVED+URI::PATTERN::RESERVED+'/')}"
      a['class'] = 'dashAnchor'
      chap.previous = a
      # puts "  Adding chapter #{entry_name}"
    end
  end
end
