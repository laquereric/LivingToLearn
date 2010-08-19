require 'test_helper'

class UsNjSesProviderTest < ActiveSupport::TestCase
  attr_accessor :filename

  def setup
  end

  def test_ods_cell_values
    self.filename= File.join( RAILS_ROOT, "test" , "fixtures" , "US_NJ_SES_PROVIDERS.ods")
    confirm_cell_values
  end

  def confirm_cell_values
    spreadsheet= Spreadsheet::SesProviders.load_record_file( filename )

    assert_equal Organization::SesProvider.count, 2

    assert_equal spreadsheet.cell(2,1),"#1 in Learning"
    assert_equal Organization::SesProvider.first.name,"#1 in Learning"

    assert_not_nil spreadsheet.cell(3,2).match(/Brandon/)
    assert_not_nil Organization::SesProvider.first.contact.match(/Brandon/)

    assert_equal spreadsheet.cell(4,2),"All of New Jersey"
    assert_equal Organization::SesProvider.first.areas_served,"All of New Jersey"

    assert_not_nil spreadsheet.cell(4,3).match(/Literacy/)
    assert_not_nil Organization::SesProvider.first.services.match(/Literacy/)
    
    assert_not_nil spreadsheet.cell(4,4).match(/ATOK/)
    assert_not_nil Organization::SesProvider.first.qualifications.match(/ATOK/)

#####

    assert_equal spreadsheet.cell(5,1),"1 to 1 Tutor"
    assert_equal Organization::SesProvider.all[1].name,"1 to 1 Tutor"

  end

end
