class GoogleApi::Folder < GoogleApi::Client
  cattr_accessor :list

  def self.get_list
    return self.list if !self.list.nil?
    self.login
    raw_list = self.service.folders
    self.list = raw_list.map{ |rf|
      path= []
      cursor = rf
      while !cursor.nil? do
        path.push cursor.title
        cursor = cursor.parent
      end
      path.reverse
      { :folder => rf, :path => path.reverse }
    }
    self.list
  end

  def self.find_by_path_array(path_array)
    fs = self.get_list.select{ |f|
      pt = f[:path]
      match = true
      if path_array.length != pt.length
        match = false
      else
        path_array.each_index{ |i|  
          match = false if pt[i] != path_array[i]
        }
      end
      match
    }
    return fs[0][:folder]
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
