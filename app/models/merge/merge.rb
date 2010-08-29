class Merge::Merge
  cattr_accessor :original_document_filename
  cattr_accessor :type_symbol

####

  def self.type_cursor_filename
    File.join( RAILS_ROOT, 'cursors', 'Merge' )
  end

  def self.set_type_cursor(key)
    text = {:type_symbol => key}.to_yaml
    File.open(self.type_cursor_filename, 'w') { |f|
      f.write(text)
    }
  end

  def self.get_type_cursor
    cursor_file= File.open(self.type_cursor_filename, 'r')
    text= cursor_file.read
    hash= YAML.load(text)
    hash[:type_symbol]
  end

#####

  def self.name_cursor_filename
    File.join( RAILS_ROOT, 'cursors','Merge' )
  end

  def self.set_name_cursor(key)
    text = {:name_symbol => key}.to_yaml
    File.open(self.doc_cursor_filename, 'w') { |f|
      f.write(text)
    }
  end

  def self.get_doc_cursor
    cursor_file= File.open(self.name_cursor_filename, 'r')
    text= cursor_file.read
    hash= YAML.load(text)
    hash[:name_symbol]
  end

  def self.document_filename(name_symbol)
    return "#{self.type_symbol.to_s}_#{name_symbol.to_s}.odt"
  end

####

  def self.tmp_document_filename
    return "document.odt"
  end

  def self.tmp_dir
    return File.join(RAILS_ROOT,'tmp','merge',self.type_symbol.to_s)
  end

  def self.documents_dir
    return File.join(RAILS_ROOT,'open_office')
  end

  def self.original_document_path(name_symbol)
    File.join(self.documents_dir,self.document_filename(name_symbol))
  end

  def self.tmp_document_path(name_symbol)
    File.join(self.tmp_dir,self.tmp_document_filename)
  end

  def self.clear_tmp_document(name_symbol)
    %x[rm -f #{self.tmp_document_path(name_symbol)}]
  end

  def self.get_document(name_symbol)
     %x[mkdir -p #{self.tmp_dir}]
     self.clear_tmp_document(name_symbol)
     p "MOVING: #{original_document_path(name_symbol)}  TO: #{tmp_document_path(name_symbol)}"
     %x[cp -f #{original_document_path(name_symbol)} #{tmp_document_path(name_symbol)}]
  end

  def self.tmp_list_path(list_symbol)
    File.join(self.tmp_dir,list_symbol.to_s)
  end

  def self.swriter(name_symbol)
     self.get_document(name_symbol)
    %x[swriter #{tmp_document_path(name_symbol)} &]
  end

end
