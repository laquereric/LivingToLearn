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

  def move_doc_to_tmp( doc_type, doc_file_path, csv_content )
    %x[mkdir -p #{self.tmp_dir}]
    tmp_document_path= File.join( self.tmp_dir, "#{doc_type.to_s}.odt" )

    p "Moving DOCUMENT: #{doc_file_path} TO: #{tmp_document_path}"
    %x[cp -f #{doc_file_path} #{tmp_document_path} ]
  end

  def write_csv( doc_type, doc_file_path, csv_content )
    csv_document_path= File.join( self.tmp_dir, "#{doc_type.to_s}.csv" )
    p "Writing CSV: #{csv_document_path}"
    File.open(csv_document_path, 'w') { |f|
      f.write(csv_content)
    }
  end

  def communication_class
    cn= self.class.to_s
    cn.split('::')[1..-1].map{|n| n.underscore}.join('__')
  end

  def date_time
    DateTime.now.strftime("%Y_%m_%d_%H_%M_%S")
  end

  def filename
    "#{communication_class}__#{date_time}_produce"
  end

  def send_file( dir, target_path )
    %x[mkdir #{ dir }]
    %x[cd #{ tmp_dir } && tar -zcvf #{ target_path }.gzip ./* && cd #{RAILS_ROOT}]
  end

  def send_file_to_shared()
    dir= ENV['SHARED_COMMUNICATIONS_DIR']
    send_file(dir,File.join( dir, filename ) )
  end

  def send_file_to_archive()
    dir= ENV['ARCHIVED_COMMUNICATIONS_DIR']
    send_file( dir, File.join( dir, filename ) )
  end

  def save_merge( doc_type, doc_file_path, csv_content )
    move_doc_to_tmp( doc_type, doc_file_path, csv_content )
    write_csv( doc_type, doc_file_path, csv_content )
    send_file_to_archive()
    send_file_to_shared()
  end

end
