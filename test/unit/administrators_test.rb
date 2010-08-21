require 'test_helper'

class AdminstratorsTest < ActiveSupport::TestCase
  attr_accessor :filename

  def setup
  end

  def test_google_doc_cell_values
    self.filename = File.join( "test" , "fixtures" , "ADMINISTRATORS.gxls" )
    confirm_cell_values
  end

  def test_ods_cell_values
    self.filename= File.join( RAILS_ROOT, "test" , "fixtures" , "ADMINISTRATORS.ods")
    confirm_cell_values
  end

  def confirm_cell_values
    spreadsheet= Spreadsheet::Administrators.load_record_file( filename )
    assert  Spreadsheet::Administrators.check_headers, true
    Spreadsheet::Administrators.headers.each_index{ |index|
      assert_equal spreadsheet.cell(1,index+1),Spreadsheet::Administrators.headers[index]
    }
  end

end
