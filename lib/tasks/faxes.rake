namespace :faxes do

  desc "download"
  task :download  => :environment do
    p "Download Faxes"
    Document::Fax.download_fax_zip_file
  end

  desc "download_file"
  task :download_filename  => :environment do
    fn= Document::Fax.get_download_fax_zip_filename
    p "Download Faxes: #{fn}"
  end

end

