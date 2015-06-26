require 'sqlite3'
require_relative 'ffmpeg_doc'

class FfmpegDocset
  attr_reader :path

  def initialize(path)
    @path = path
    db.execute "CREATE TABLE IF NOT EXISTS searchIndex (id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
    db.execute "CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);"
  end

  def add(input_path)
    doc = FfmpegDoc.new(input_path, self)
    doc.index
    doc.write
  end

  def db
    @db ||= SQLite3::Database.new(File.join(@path, "/Contents/Resources/docSet.dsidx" ))
  end
end
