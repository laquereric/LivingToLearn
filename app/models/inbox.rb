#require 'zip'
require 'zip/zipfilesystem'
class Inbox

  def self.each_filename(&block)
    Dir.glob(File.join(RAILS_ROOT,'inbox','*')).each{ |filename|
      yield filename
    }
  end

  def self.make_tmpname(basename)
    random_number = (Kernel.rand*10_000_000_000_000).to_i
    sprintf('%s%s-%d-%d',  Dir::tmpdir,basename, $$ , random_number)
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

p "zip file with #{self.zip_length(filename)} entries"
        Zip::ZipFile.open(filename){ |zipfile|
#p zipfile.dir.methods.sort
          zipfile.entries.each{ |entry|
p entry.name
p 'is_directory' if entry.is_directory
            entry_name_split = entry.name.split('.')
            entry_name_exts = entry_name_split[1..-1]
            entry_name_base = entry_name_split[0]
            dest_file_path_base = self.make_tmpname("#{cfilename}_#{entry_name_base.gsub('/','_')}")
            dest_file_path = [dest_file_path_base,entry_name_exts].flatten.join('.')
p dest_file_path
#debugger
            entry.extract(dest_file_path){
p 'exists'
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

  def self.files
    self.each_filename_flat{ |fn|
      p fn
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
