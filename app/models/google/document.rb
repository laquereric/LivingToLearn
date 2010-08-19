class Google::Document < Google::Client

  def self.get_document_list
    self.login
    self.service.files
  end

  def self.get_folder_list
    self.login
    self.service.folders
  end

end
