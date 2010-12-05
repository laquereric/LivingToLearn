namespace :faxes do

  desc "download"
  task :download  => :environment do
    p "Download Faxes"
    num_faxes= Document::Fax.download_fax_zip_files
    p "Downloaded #{num_faxes} faxes"
    zfns= Document::Fax.get_download_fax_zip_filenames
    p "Found #{zfns.length} fax zip files"
    if num_faxes > 0 and zfns.length == 0
      p "Error!"
      0/0
    end
    zfns.each{ |zfn|
      p "Pdf from #{zfn}"
      pdf_fns= Document::Fax.pdf_fax_filenames(zfn)
      pdf_fns.each{ |pdf|
        Document::Fax.mv_to_faxes(pdf)
      }
      %x( rm #{zfn} )
    }
  end

end

