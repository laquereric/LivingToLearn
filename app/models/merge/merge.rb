class Merge::Merge
  cattr_accessor :original_document_filename

  def self.document_filename(name_symbol)
    return "#{self.type_symbol.to_s}_#{name_symbol.to_s}.odt"
  end

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

#  def self.clear_merged
#    %x[rm -rf  #{ self.tmp_merged_dir }]
#  end

#  def self.swriter_letter_ses_administrators_intro()
#    self.swriter_letter('ses_administrators_intro')
#  end

end
