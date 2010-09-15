class Document::OoWriter < Document::Merge

  def extension
    'odt'
  end

  def dir
    return ENV['SHARED_OPENOFFICE_DIR']
  end

end
