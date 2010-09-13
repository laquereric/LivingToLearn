class Document::PostcardsSeries <  Document::OoWriter

  def type
    :postcards_series
  end

  def csv_klass
    Dataset::CsvSeries
  end

end
