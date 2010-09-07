require 'zip/zip'
class Communication::Communication
  attr_accessor :dataset

  def get_dataset
    self.dataset= Dataset::Dataset.new
  end

  def tmp_dir
    return File.join(RAILS_ROOT,'tmp','communication')
  end

  def init_tmp_dir()
    %x[rm -r #{tmp_dir}] if File.exists?(tmp_dir)
  end

  def zip_file_name
    return File.join(RAILS_ROOT,'communications','communication')
    #return File.join(RAILS_ROOT,'tmp','communication')
  end

  def zip()
=begin
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) { |zipfile|
    puts zipfile.read("first.txt")
    zipfile.remove("first.txt")
  }
=end
  end

  def save_merge(  doc_type, doc_file_path, csv_content)

    %x[mkdir -p #{self.tmp_dir}]
    tmp_document_path= File.join( self.tmp_dir, "#{doc_type.to_s}.odt" )

    p "Moving DOCUMENT: #{doc_file_path}  TO: #{tmp_document_path}"
    %x[cp -f #{doc_file_path} #{tmp_document_path} ]

    csv_document_path= File.join( self.tmp_dir, "#{doc_type.to_s}.csv" )
    p "Writing CSV: #{csv_document_path}"
    File.open(csv_document_path, 'w') { |f|
      f.write(csv_content)
    }

  end

end
