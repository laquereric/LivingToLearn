class DocBase < ActiveRecord::Base

  def rotate_180
    %x{ pdftk A=#{self.filename} cat A1D output #{'tmp_filename'}}
    %x{ mv #{'tmp_filename'} #{self.filename} }
    #%x{ rm #{'tmp_filename'} }
  end

  def merge_meta
    return false if !is_pdf?
    #tmp_filename = "#{Tmp.name('with_merged_meta')}.pdf"
    %x{ pdftk #{self.filename} update_info #{self.meta_filename} output #{'tmp_filename'} }
    %x{ mv #{'tmp_filename'} #{self.filename} }
    #%x{ rm #{self.meta_filename} }
    return true
  end

  def remove
    %x{rm #{self.meta_filename} }
    %x{rm #{self.filename} }
  end

  def self.find_for_client(client)
    self.all.select{ |f|
      mnemonic = f.meta_hash['OwnedByMnemonic']
      r = if mnemonic
        client_id = Person::Client.mnemonic_to_id(mnemonic)
        (client_id == client.client_id.to_i)
      else
        false
      end
    }
  end

  def add_owned_by_client_meta(client_id)
    client = Person::Client.find_by_client_id(client_id.to_f)
    return false if !client
    client_mnemonic = client.mnemonic
#p client_mnemonic
    self.add_meta( 'OwnedByMnemonic',client_mnemonic )
    return true
  end

  def preview
    %x{open -a Preview #{self.filename} }
  end

  def self.push(fn)
  end

  def self.push(fn)
    file_split = File.split(fn)
    burst_page = !file_split[-1].match(/^pg_/).nil?
    new_fn_base = if burst_page
      [ file_split[0].split('/')[-1] , file_split[-1] ].join('_')
    else
      file_split[-1]
    end

    new_fn = File.join(self.dir,new_fn_base)

    p new_fn

    %x{mv #{fn} #{new_fn} }

    #create_thumbnail_for(new_fn)

  end

  def self.dir
    return File.join(RAILS_ROOT,'doc_base')
  end

  def self.each_doc_filename(&block)
    Dir.glob(File.join(self.dir,'*')).each{ |filename|
      next if self.is_meta_filename?(filename)
      yield filename
    }
  end

  def add_meta(key,value)
    lines = ["InfoKey: #{key}","InfoValue:  #{value}"]
    self.meta<< lines.join("\n")
    self.meta<< "\n"
    File.open(self.meta_filename,'w'){ |f|
      f.write(self.meta)
    }
    self.merge_meta
  end

  def meta_hash
    r = {}
    line_array = self.meta.split("\n")

    index = 0
    while index < line_array.length do
      key_line_array = line_array[index].split(':')
      index += 1

      key_line_array_0 = key_line_array[0]
      is_number_of_pages = key_line_array_0.strip.match(/NumberOfPages/)
      is_info_key = key_line_array_0.strip.match(/InfoKey/)
      is_pdf_id = key_line_array_0.strip.match(/PdfID(.*)/)
      if is_info_key
        key = key_line_array[1].strip
        value_line_array = line_array[index].split(':')
        index += 1

        value_line_array_0 = value_line_array[0]
        is_info_value = value_line_array_0.strip.match(/InfoValue/)
        1/0 if !is_info_value
        value = value_line_array[1..-1].join(':').strip
        r[key] = value
      elsif is_pdf_id or is_number_of_pages
      else
        1/0
      end
    end
    return r
  end

  def meta_filename
    "#{self.filename}.meta"
  end

  def save_meta_to_file()

    File.open(self.meta_filename,"w"){ |meta_file|
      meta_file.write(self.meta)
    }

  end

  def self.is_pdf_filname?(filename)
    return ( File.split(filename)[-1].split('.')[-1] == 'pdf' )
  end

  def is_pdf?
    return  self.class.is_pdf_filname?(self.filename)
  end

  def self.is_meta_filename?(filename)
    return ( File.split(filename)[-1].split('.')[-1] == 'meta' )
  end

  def get_meta_from_pdf()
    self.meta = %x{pdftk #{self.filename} dumpdata}
  end

  def self.new_for_filename(fn)

    (doc_base = self.new).filename = fn

    if File.exists?( doc_base.meta_filename ) then
      File.open(doc_base.meta_filename,"r"){ |meta_file|
        doc_base.meta = meta_file.read
      }
    elsif doc_base.is_pdf?
      doc_base.get_meta_from_pdf
      doc_base.save_meta_to_file
    end

    return doc_base

  end

  def self.all
    rs = []
    self.each_doc_filename{ |fn|
      rs << self.new_for_filename(fn)
    }
    return rs
  end

end

=begin
  def self.create_thumbnail_for(fn)
    gs_cmds << '-dTextAlphaBits=4'
    gs_cmds << '-dGraphicsAlphaBits=4'
    gs_cmds << '-dNOPAUSE'
    gs_cmds << '-dBATCH'
    gs_cmds << '-sDEVICE=png16m'
    gs_cmds << '-r9.06531732174037'
    gs_cmds << "-sOutputFile=#{fn}_thumbnail.png"
    gs_cmds << <<eos
-c "save pop currentglobal true setglobal false/product where{pop product(Ghostscript)search{pop pop pop revision 600 ge{pop true}if}{pop}ifelse}if{/pdfdict where{pop pdfdict begin/pdfshowpage_setpage[pdfdict/pdfshowpage_setpage get{dup type/nametype eq{dup/OutputFile eq{pop/AntiRotationHack}{dup/MediaBox eq revision 650 ge and{/THB.CropHack{1 index/CropBox pget{2 index exch/MediaBox exch put}if}def/THB.CropHack cvx}if}ifelse}if}forall]cvx def end}if}if setglobal
eos
    gs_cmds << "-f #{fn}.pdf"
    gs_cmds = []
    %x{ gs gc_cmds.join(' ')}
  end
=end



=begin

# gs -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dNOPAUSE -dBATCH -sDEVICE=png16m -r9.06531732174037 -sOutputFile=thb%d.png -c "save pop currentglobal true setglobal false/product where{pop product(Ghostscript)search{pop pop pop revision 600 ge{pop true}if}{pop}ifelse}if{/pdfdict where{pop pdfdict begin/pdfshowpage_setpage[pdfdict/pdfshowpage_setpage get{dup type/nametype eq{dup/OutputFile eq{pop/AntiRotationHack}{dup/MediaBox eq revision 650 ge and{/THB.CropHack{1 index/CropBox pget{2 index exch/MediaBox exch put}if}def/THB.CropHack cvx}if}ifelse}if}forall]cvx def end}if}if setglobal" -f document.pdf

=end
