class Communication::SesAlumni::ComeBack < Communication::Communication

  attr_accessor :school_district
  attr_accessor :postcards_series


  def map_school_to_district(school)

    sd_code= case
      when school =~ /Woodbury/ : 5860
      when school =~ /Evergreen/ : 5860
      when school =~ /Winslow/ : 5820
      when school =~ /Highland/ : 390
      when school =~ /Triton/ : nil
      when school =~ /Camden Co/ : 700
      when school =~ /Gateway/ : 1715
      when school =~ /Clearview/ : 870
      when school =~ /Glassboro/ : 1730
      when school =~ /Simmons/ : nil
      when school =~ /Clementon/ : nil
      when school =~ /Clearview/ : nil
      when school =~ /Erial Christian/ : nil
      when school =~ /Williamstown/ : nil
      else nil
    end

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
    self.school_district= Government::SchoolDistrict.find_by_district_code(school_district_code)
    self.dataset.common_hash=
      self.school_district_ses_hash(school_district)
    self.dataset.record_hash_array=
      self.ses_clients_hash()

  end

  def use_row?(row_hash)
    ( map_school_to_district( row_hash[:school] ) == self.school_district.district_code )
  end

  def ses_clients_hash

    spreadsheet= Spreadsheet::SesClients.new()
    return Spreadsheet::SesClients.record_hash_array.select{ |rh| use_row?(rh) }

  end

  def label(d)

    d.program= 'SesAlumni'.underscore.to_sym
    d.name= 'ComeBack'.underscore.to_sym
    d

  end

  def set_data(d)
    d.set_data(self.dataset)
    d
  end

  def get_postcards_series

    d= Document::PostcardsSeries.new()
    label( d )
    set_data( d )

  end

  def produce

    init_tmp_dir()
    get_dataset

    m= get_postcards_series
    save_merge( m.type , m.path, m.csv_content )

    self.zip_communication_file()

  end

end
