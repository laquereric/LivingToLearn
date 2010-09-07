class Document::PostcardsSeries <  Document::OoWriter

  def type
    :postcard
  end

  def csv_klass
    Dataset::CsvSeries
  end

end
