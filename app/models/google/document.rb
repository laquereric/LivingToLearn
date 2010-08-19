class Google::Document < Google::Client
  cattr_accessor :document_list
  cattr_accessor :folder_list

  def self.get_document_list
    return self.document_list if !self.document_list.nil?
    self.login
    self.document_list= self.service.files
  end

  def self.get_folder_list
    return self.folder_list if !self.folder_list.nil?
    self.login
    self.folder_list= self.service.folders
  end

  def self.find_by_title(title)
    self.get_document_list.select{ |doc| doc.title == title }
  end

  def self.find_by_type(type)
    self.get_document_list.select{ |doc|
      doc_type= doc.title.split('_')[-1]
      ( doc_type == type )
    }
  end

end
