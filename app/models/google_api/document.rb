class GoogleApi::Document < GoogleApi::Client
  cattr_accessor :list

  def self.find(pathext)
    path,full_name= File.split(pathext)
    name,ext= full_name.split('.')
    return nil if ext != 'gxls'

    service= self.login
    docs = GDocs4Ruby::BaseObject.find(service, {:title => name},'any')
    return docs[0]
  end

  def self.find_by_path_array(path_array)
    folder = GoogleApi::Folder.find_by_path_array(path_array[0..-2])[0][:folder]
    files = folder.files.select{ |file|
      file.title == path_array[-1]
    }
    files[0]
  end

  def self.get_list
    return self.list if !self.list.nil?
    self.login
    self.list= self.service.files
  end

  def self.find_by_title(title)
    self.get_list.select{ |doc| doc.title == title }
  end

  def self.find_by_type(type)
    self.get_list.select{ |doc|
      doc_type= doc.title.split('_')[-1]
      ( doc_type == type )
    }
  end

end
