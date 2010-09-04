namespace :spreadsheet do

  namespace :get_church_leader_csv do
    desc "Church Leaders"
    task :for_school_district => :environment do
      sd= Government::SchoolDistrict.at_cursor
      sd.csv_spreadsheet(:church_leaders)
    end
  end

  namespace :global do
    desc "Initialize SES Funding Data"
    task :initialize_ses_funding_data => :environment do
      p "Rake Task spreadsheet:initialize_ses_funding_data"
      filename= File.join( "TutoringClub" , "Data" , "us_nj_ses_funding.gxls")
      p "Loading google spreadsheet: #{filename}"
      spreadsheet= Spreadsheet::SesFunding.load_record_file( filename )
      p "Loaded google spreadsheet: #{filename} with #{Government::SchoolDistrict.count} School Districts"
    end
  end

end

