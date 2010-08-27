namespace :spreadsheet do

  namespace :set_cursor do
    desc "Black Horse Pike Regional"
    task :church_leaders => :environment do
       Spreadsheet::Spreadsheet.set_cursor(:church_leaders)
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

