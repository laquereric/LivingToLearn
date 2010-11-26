require 'rubygems'
require 'pdf/reader'
class Document::Pdf <  Document
  set_table_name :document_pdfs
  attr_accessor :pages

  def page_count(arg)
    @pages = arg
  end

  def self.parse(fn)
p "parsing #{fn}"
    receiver= self.new
    fn.gsub!(/~/,'/Users/eric')
    receiver.filename= fn
    pdf = PDF::Reader.file(fn, receiver, :pages => false)
    puts " #{receiver.pages} pages"
  end
end
