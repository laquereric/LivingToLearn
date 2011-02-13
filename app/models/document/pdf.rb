require 'rubygems'
require 'pdf/reader'

class Document::Pdf #< Document
  #set_table_name :document_pdfs

  attr_accessor :filename
  attr_accessor :pages
  attr_accessor :doc

  def self.tmp_dir
    return File.join(RAILS_ROOT,'tmp','pdf_manipulate')
  end

  def self.init_tmp_dir()
    %x[rm -r #{tmp_dir}] if File.exists?(tmp_dir)
    %x[mkdir #{tmp_dir}]
  end

  def page_count(arg)
    self.pages = arg
  end

  def self.parse(fn)
    receiver= self.new
    receiver.filename= fn
    receiver.doc = PDF::Reader.file(fn, receiver, :pages => false)
    return receiver
  end

  def self.length(fn)
    receiver= self.parse(fn)
    return receiver.pages
  end

  def self.burst(fn)
    return nil if !File.exists?(fn)
    local_path= fn.split('/')[-1]
    base_path= local_path.split('.')[0]
    sys_path=  fn.split('/')[0..-2].join('/')
    self.init_tmp_dir()
    tmp_dir = Tmp.dir("")
    %x(cd #{self.tmp_dir}; cp #{fn} . )
    %x(cd #{self.tmp_dir}; pdftk ./#{local_path} burst )
    pages= Dir.glob( File.join(self.tmp_dir, "pg*.pdf") )
    pages.each{ |pg|
       pgn= pg.split('/')[-1].split('.')[0]
       pg_fn= File.join(sys_path,"#{base_path}.#{pgn}.pdf")
       %x(cp #{pg} #{pg_fn} )
       p "#{pg_fn} created"
    }
    nfm= File.join(sys_path,"#{base_path}.master.pdf")
    p "new file name: #{nfm}"
    %x(cp #{fn} #{nfm})
    %x(rm #{fn})
  end

  def self.cat( file_name_array, output_filename )
    cmd = "pdftk "
    i = 0

    ('A'..'Z').step{ |l|
      break if i >= file_name_array.length
      cmd << "#{l}=#{file_name_array[i]} "
      i += 1
    }

    cmd << "cat "

    ('A'..'Z').step{ |l|
      break if i >= file_name_array.length
      cmd << "#{l} "
      i += 1
    }

    cmd << " output #{output_filename}"

p cmd
    %x{ #{cmd} }
  end
end
