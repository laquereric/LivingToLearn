require 'zip/zipfilesystem'
class Inbox

  def self.each_filename(&block)
    Dir.glob(File.join(RAILS_ROOT,'inbox','*')).each{ |filename|
      yield filename
    }
  end

  def self.zip_length(filename)
    count = 0
    Zip::ZipFile.foreach(filename){ |entry|
      count += 1
    }
    return count
   end

   def self.zip_empty?(filename)
     return ( self.zip_length(filename) == 0 )
   end

   def self.each_filename_flat(&block)
    self.each_filename{ |filename|
      cfilename = File.split(filename)[-1].gsub('.','_')
      if filename.split('.')[1] == 'zip'
        Zip::ZipFile.open(filename){ |zipfile|
          zipfile.entries.each{ |entry|
            dest_file_path_base = Tmp.name("#{cfilename}_#{Tmp.basename(entry.name)}")
            dest_file_path = [dest_file_path_base,Tmp.exts(entry.name)].flatten.join('.')
            entry.extract(dest_file_path){
#p 'exists'
            }
            delete_it = yield dest_file_path
            zipfile.remove(entry.name) if delete_it and File.exists?(entry.name)
          }
        }
        if self.zip_empty?(filename)
          File.delete(filename)
        end
      else
        delete_it = yield filename
        File.delete(filename) if delete_it and File.exists?(entry.name)
      end
    }
  end

  def self.each_pdf_filename_flat(&block)
    self.each_filename_flat{ |filename|
      r = if filename.split('.')[-1] == 'pdf' then
        yield(filename)
      else
        false
      end
    }
  end

  def self.each_pdf_page_filename_flat(&block)
    self.each_pdf_filename_flat{ |filename|
      if ( l = Document::Pdf.length( filename ) ) == 1
        yield( filename )
      else
        burst_dir = Tmp.dir(Tmp.basename(filename))
        %x(cd #{burst_dir}; pdftk #{filename} burst )
        Dir.glob( File.join(burst_dir, "pg*.pdf") ).each{ |pg| yield pg }
      end
    }
  end

  def self.push_pdf_pages
    self.each_pdf_page_filename_flat{ |fn|
      Outbox.push(fn)
      false
    }
  end

  def self.delete_files
    self.each_filename_flat{ |fn|
      p "deleting: #{fn}"
      true
    }
  end

end
