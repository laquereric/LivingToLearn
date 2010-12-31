class Contract::SchoolDistrict < ActiveRecord::Base

  set_table_name :contract_school_districts

  # will print two invoice lines
  def self.has_master_slave_contracts?( d )
    ca= self.get_for_sd(d)
    return ( ca[0].master_sub == 'M' )
  end

  # will print only one invoice line
  def self.has_two_contracts?( d )
     ca = self.get_for_sd(d)
     return ( ca.length == 2 )
  end

  # wil print only one invoice line
  def self.second_invoice_line?( d )
    return self.has_master_slave_contracts?(d)
  end

  def merge_sub( s )
    self.rate = s.rate
    self.name = s.name
    self.master_sub= 'I'
    return self
  end

  def self.fc_for_sd( d )
    ca= get_for_sd( d )
    #r = if ca[0].master_sub != 'M' then
    r = if !self.has_master_slave_contracts?( d ) then
      ca[0]
    else
       ca[0].merge_sub( ca[1] )
    end
    return r
  end

  def self.sc_for_sd( d )
    ca= get_for_sd( d )
    p "district w/o contract? #{d.inspect}" if ca.nil?
    r = if !self.has_master_slave_contracts?(d) then
    #r = if ca[0][:master_sub] != 'M' then
      ca[1]
    else
      ca[0].merge_sub( ca[2] )
    end
    return r
  end

  def self.get_for_sd( d )
    hs = self.send("get_#{ d.government_district_code }")
    return hs.map{ |h| self.create( h ) }
  end

 #7520__PleasanTech"
  def self.get_7520
    h = {
      :name => 'only',
      :school_district_id => 7520 ,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 1235.00
    }
    return [ h ]
  end

  #"5860__WOODBURY_CITY"
  def self.get_5860
    h = {
      :name => 'only',
      :school_district_id => 5860,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 1037.00
    }
    return [ h ]
  end

  #3280__MONROE_TOWNSHIP"
  def self.get_3280
    h = {
      :name => 'only',
      :school_district_id => 3280,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 1297.00
    }
    return [ h ]
  end

  #2990__MANTUA_TOWNSHIP"
  def self.get_2990
    h = {
      :name => 'only',
      :school_district_id => 2990,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 680.00
    }
    return [ h ]
  end

  #1940__HAMILTON_TOWNSHIP"
  def self.get_1940
    h = {
      :name => 'only',
      :school_district_id => 5860,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 1245.00
    }
    return [ h ]
  end

  #0390__BLACK_HORSE_PIKE_REGIONAL
  def self.get_0390
    h0 = {
      :school_district_id => 390 ,
      :name => 'first_group',
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 2146.00
    }
    h1 = {
      :school_district_id => 390 ,
      :name => 'second_group',
      :date => 11/2/2010,
      :rate => 43.67,
      :per_pupil_amount => 836.00
    }
    return [ h0 , h1 ]
  end

  #5820___WINSLOW_TOWNSHIP
  def self.get_5820
    h= {
      :name => 'only',
      :school_district_id => 5820,
      :date => 11/1/2010,
      :rate => 43.67,
      :per_pupil_amount => 1344.00
    }
    return [ h ]
  end

  #1730__GLASSBORO
  def self.get_1730
    h0= {
      :school_district_id => 1730 ,
      :name => 'home_school',
      :date => 11/1/2010,
      :master_sub => 'M',
      :per_pupil_amount => 1575.00
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
    return [ h0 , h1 , h2 ]
  end

end
