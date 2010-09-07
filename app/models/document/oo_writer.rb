class Document::OoWriter < Document::Merge

  def extension
    'odt'
  end

  def dir
    return File.join(RAILS_ROOT,'open_office')
  end

=begin

  def self.document_path(name_symbol)
    File.join(self.documents_dir,self.document_filename(name_symbol))
  end

  def self.swriter(name_symbol)
     self.get_document(name_symbol)
    %x[swriter #{tmp_document_path(name_symbol)} &]
  end
=end

end
