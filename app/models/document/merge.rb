class Document::Merge

  attr_accessor :program
  attr_accessor :type
  attr_accessor :name
  
  attr_accessor :dataset

  def csv_klass
    Dataset::Csv
  end

  def set_data(dataset)
    self.dataset= csv_klass.new()
    self.dataset.set_data( dataset )
  end

  def csv_content
    dataset.get_output
  end

  def dtype
    self.class.to_s.split('::')[-1].underscore.to_sym
  end

  def extension
    nil
  end

  def filename
    fn = ""
    fn<< "#{self.program.to_s}__" if self.program
    fn<< "#{self.dtype.to_s}__" if self.dtype
    fn<< "#{self.name.to_s}" if self.name
    fn<<  ".#{self.extension}" if self.extension
    fn
  end

  def path
    return File.join(self.dir,self.filename)
  end

end
