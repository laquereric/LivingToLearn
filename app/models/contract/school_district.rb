class Contract::SchoolDistrict < ActiveRecord::Base

  set_table_name :contract_school_districts

  def self.get_for_sd(d)
    hs= self.send("get_#{d.government_district_code}")
    return hs.map{ |h| self.create(h) }
  end

 #7520__PleasanTech"
  def self.get_7520
    h= {
      :school_district_id => 7520 ,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #"5860__WOODBURY_CITY"
  def self.get_5860
    h= {
      :school_district_id => 5860,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #3280__MONROE_TOWNSHIP"
  def self.get_3280
    h= {
      :school_district_id => 3280,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end


  #2990__MANTUA_TOWNSHIP"
  def self.get_2990
    h= {
      :school_district_id => 2990,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #1940__HAMILTON_TOWNSHIP"
  def self.get_1940
    h= {
      :school_district_id => 5860,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #390__BLACK_HORSE_PIKE_REGIONAL
  def self.get_390
    h0= {
      :school_district_id => 390 ,
      :name => 'first_group',
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    h1= {
      :school_district_id => 390 ,
      :name => 'second_group',
      :date => 11/2/2010,
      :rate => 43.67,
      :per_pupil_amount => 900.00
    }
    return [h0,h1]
  end

  #5820___WINSLOW_TOWNSHIP
  def self.get_5820
    h= {
      :school_district_id=>5820,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    return [h]
  end

  #1730__GLASSBORO
  def self.get_1730
    h0= {
      :school_district_id => 1730 ,
      :name => 'home_school',
      :date => 11/1/2010,
      :master_sub => 'M',
      :per_pupil_amount => 2146.00
    }
    h1= {
      :school_district_id => 1730 ,
      :name => 'school',
      :date => 11/2/2010,
      :rate => 43.67,
      :master_sub => 'S'
    }
    h2= {
      :school_district_id => 1730 ,
      :name => 'home',
      :date => 11/2/2010,
      :rate => 70.00,
      :master_sub => 'S'
    }
    return [h0,h1,h2]
  end

end
