class Contract::SchoolDistrict < ActiveRecord::Base

  set_table_name :contract_school_districts

  def self.get_for_sd(d)
    self.send("get_#{d.government_district_code}")
  end

  #5820__WINSLOW_TOWNSHIP"
  def self.get_5820
    h= {
      :school_district_id => 5820 ,
      :number => 0,
      :school => 'Highland HS' ,
      :school_city => 'Blackwood' ,
      :school_state => 'NJ' ,
      :school_zip => '08012',
      :hours_in_program => 49.1,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #7520__PleasanTech"
  def self.get_7520
    h= {
      :school_district_id => 7520 ,
      :number => 0,
      :hours_in_program => 49.1,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #"5860__WOODBURY_CITY"
  def self.get_5860
    h= {
      :school_district_id => 5860,
      :number=> 0 ,
      :school=>1,
      :school_city=>1,
      :school_state=>1,
      :school_zip=>1,
      :hours_in_program =>1,
      :per_pupil_amount=>1
    }
    return [h]
  end

  #3280__MONROE_TOWNSHIP"
  def self.get_3280
    h= {
      :school_district_id => 3280,
      :number=>0,
      :school=>1,
      :school_city=>1,
      :school_state=>1,
      :school_zip=>1,
      :hours_in_program =>1,
      :per_pupil_amount=>1
    }
    return [h]
  end


  #2990__MANTUA_TOWNSHIP"
  def self.get_2990
    h= {
      :school_district_id => 2990,
      :number => 0,
      :school => 1,
      :school_city => 1,
      :school_state => 1,
      :school_zip => 1,
      :hours_in_program =>1,
      :per_pupil_amount => 1
    }
    return [h]
  end

  #1940__HAMILTON_TOWNSHIP"
  def self.get_1940
    h= {
      :school_district_id=>1,
      :number => 0,
      :school=>1,
      :school_city=>1,
      :school_state=>1,
      :school_zip=>1,
      :hours_in_program =>1,
      :per_pupil_amount=>1
    }
    return [h]
  end

  #390__BLACK_HORSE_PIKE_REGIONAL
  def self.get_390
    h0= {
      :school_district_id => 5820 ,
      :number => 0,
      :school => 'Highland HS' ,
      :school_city => 'Blackwood' ,
      :school_state => 'NJ' ,
      :school_zip => '08012',
      :hours_in_program => 49.1,
      :per_pupil_amount => 2146.00
    }
    h1= {
      :school_district_id => 5820 ,
      :number => 1,
      :school => 'Highland HS' ,
      :school_city => 'Blackwood' ,
      :school_state => 'NJ' ,
      :school_zip => '08012',
      :hours_in_program => 49.1,
      :per_pupil_amount => 2146.00
    }
    return [h0,h1]
  end

  #5820___WINSLOW_TOWNSHIP
  def self.get_390
    h= {
      :school_district_id=>390,
      #:school=>1,
      #:school_city=>1,
      #:school_state=>1,
      #:school_zip=>1,
      :per_pupil_amount=>1,
      :rate =>43.67,
      :hours_in_program =>1,
    }
    return [h]
  end

  #1730__GLASSBORO
  def self.get_1730
    h= {
      :school_district_id=>1730,
      #:school=>1,
      #:school_city=>1,
      #:school_state=>1,
      #:school_zip=>1,
      :per_pupil_amount=>1,
      :rate =>43.67,
      :hours_in_program =>1,
    }
    return [h]
  end

end
