class Communication::SesNonProfit::HighlandHsIntro < Communication::Communication
  attr_accessor :envelope
  attr_accessor :letter
  attr_accessor :postcards_same

  def school_district_non_profit_leaders_filter(record_hash_array)
    record_hash_array.select{ |rec| rec[:select] and rec[:select].length >= 1 }
  end

  def school_district_non_profit_leaders_hash(school_district)
    spreadsheet= Spreadsheet::NonProfitLeaders.new(school_district)
    raw= Spreadsheet::NonProfitLeaders.record_hash_array
    return school_district_non_profit_leaders_filter(raw)
  end

  def school_district_ses_hash(school_district)
    rh = {}
    rh[:country]= school_district.country_entity.name
    rh[:state]= school_district.state_entity.name
    rh[:county]= Government::County.full_name_pretty(school_district.county_entity)
    rh[:school_district]= Government::SchoolDistrict.full_name_pretty(school_district.entity)
    [
        :district_code,
        :at_risk_pupils_fy2011,
        :poverty_pupils_fy2011,
        :ses_allocation_fy2011,
        :per_pupil_allocation_fy2011,
        :after_school_hours,
        :after_school_weeks,
        :at_home_hours,
        :at_home_weeks
    ].each{ |f|
        rh[f]= school_district.send(f)
    }
    rh
  end

  def get_dataset
    super
    school_district= Government::SchoolDistrict.find_by_district_code(390)
    self.dataset.common_hash=
      self.school_district_ses_hash(school_district)
    self.dataset.record_hash_array=
      self.school_district_non_profit_leaders_hash(school_district)
  end

  def label(d)
    d.program= 'SesNonProfit'.underscore.to_sym
    d.name= 'HighlandHsIntro'.underscore.to_sym
    d
  end

  def set_data(d)
    d.set_data(self.dataset)
    d
  end

  def get_envelope
    d= Document::Envelope.new()
    label( d )
    set_data( d )
  end

  def get_letter
    d= Document::Letter.new()
    label( d )
    set_data( d )
  end

  def get_postcards_same
    d= Document::PostcardsSame.new()
    label( d )
    set_data( d )
  end

  def produce

    init_tmp_dir()
    get_dataset

    m= get_envelope
    save_merge(  m.type , m.path, m.csv_content)

    m= get_letter
    save_merge(  m.type , m.path, m.csv_content)

    m= get_postcards_same
    save_merge(  m.type , m.path, m.csv_content)

    zip_path= zip

  end

end
