require 'test_helper'

class PeriodTest < ActiveSupport::TestCase

  def setup
  end

  def test_school_year
    oct_ref= Time.utc(2000,"oct",1,20,15,1)
    oct_sy= Period.this_school_year(oct_ref)
    assert_equal oct_sy.begin_time.year, 2000
 
    feb_ref= Time.utc(2000,"feb",1,20,15,1)
    feb_sy= Period.this_school_year(feb_ref)
    assert_equal feb_sy.begin_time.year, 1999
  
  end

  def test_half_month
    fh_ref= Time.utc(2000,"oct",5,20,15,1)
    fhp= Period.this_half_month(fh_ref)
    assert_equal fhp.begin_time.day, 1

    sh_ref= Time.utc(2000,"oct",17,20,15,1)
    shp= Period.this_half_month(sh_ref)
    assert_equal shp.begin_time.day, 16
  end

end
