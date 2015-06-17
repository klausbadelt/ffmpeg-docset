require 'nokogiri'
require 'sqlite3'
require 'fileutils'

doc = Nokogiri::HTML(ARGF.read)
db = SQLite3::Database.new( "_output/ffmpeg.docset/Contents/Resources/docSet.dsidx" )
db.execute "CREATE TABLE IF NOT EXISTS searchIndex (id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
db.execute "CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);"

doc.css("h1.chapter > a").each do |node|
  chapter = node.content
  type = 'Guide'
  path = node[:href]
  db.execute "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?);", [chapter, type, path]
end
