require 'test_helper'

class LocalPayersTest < ActiveSupport::TestCase
  attr_accessor :filename

  def setup
  end

  def test_google_cell_values
    return if ENV['GOOGLE_TEST'] == 'false'
    self.filename= File.join( "test" , "fixtures" , "LocalPayers.gxls")
    confirm_cell_values
    confirm_hash_values
    confirm_record_values
  end

  def test_ods_cell_values
    self.filename= File.join( RAILS_ROOT, "test" , "fixtures" , "LocalPayers.ods")
    confirm_cell_values
    confirm_hash_values
    confirm_record_values
  end

  def confirm_cell_values
    spreadsheet= Spreadsheet::LocalPayers.get_spreadsheet(filename)
    assert_equal spreadsheet.cell(1,1),'Prospect Id'
    assert_equal spreadsheet.cell(1,2), 'Prefix'
    assert_equal spreadsheet.cell(2,1),1.0
    assert_equal spreadsheet.cell(2,2), 'Mr.'
    assert_equal spreadsheet.cell(2,3),"Joseph"
  end

#####

  def confirm_hash_values
    hash_array= Spreadsheet::LocalPayers.get_hash_array(filename)
    assert_equal hash_array.length, 2
    assert_equal hash_array[0][:prefix], 'Mr.'
    assert_equal hash_array[0][:first_name], "Joseph"
    assert_equal hash_array[1][:last_name], 'Abate'
  end

  def confirm_record_values
    records= Spreadsheet::LocalPayers.store(filename)
    assert_equal Person::ParentPotentialPayer.count, 2
    assert_equal records[0].entity.first_name, 'Joseph'
    assert_equal records[0].entity.locations.length,1
    assert_equal records[0].entity.locations[0].city,'Blackwood'
  end

end
