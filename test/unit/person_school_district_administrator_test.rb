require 'test_helper'

class PersonSchoolDistrictAdministratorTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    sda_entity, sda_details =
      Person::SchoolDistrictAdministrator.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    assert_equal sda_entity.errors.count, 0
    assert_equal sda_entity.entity_details.count , 1
    assert_equal sda_details.length , 1
  end

  def test_should_be_able_to_associate
    sd_entity, sd_details =
      Government::SchoolDistrict.add_entity_detail( { :name=>"Washington Township School District"})
    sd_detail= sd_details[0]
 
    sda_entity, sda_details =
      Person::SchoolDistrictAdministrator.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    sda_detail=sda_details[0]

    sda_detail.government_school_district_detail= sd_detail
    sda_detail.save
    assert_not_nil sda_detail.government_school_district_detail
    assert_equal sd_details[0].person_school_district_administrator_details.length, 1
  end

end
