class Document::PostcardsSame <  Document::OoWriter

  def type
    :postcard
  end

  def csv_klass
    Dataset::CsvSame
  end

end
