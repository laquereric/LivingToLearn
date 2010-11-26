require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  def setup
  end

  def test_is_abstract
    dte = Detail.table_exists?
    assert !dte
  end

end
