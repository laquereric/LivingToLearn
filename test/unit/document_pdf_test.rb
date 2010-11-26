require 'test_helper'

class DocumentPdfTest < ActiveSupport::TestCase

  def setup
  end

  def test_is_abstract
    assert Document::Pdf.table_exists?
  end

end
