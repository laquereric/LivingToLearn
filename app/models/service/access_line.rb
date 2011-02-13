class Service::AccessLine

  def self.browse_accessline
     Browser.get_browser.goto("https://www.accessline.com/login.asp?nav=login")
  end

  def self.browse_frame(did,pin)
    browser= self.browse_accessline
    did_field= browser.text_fields[1]
    pin_field= browser.text_fields[0]
    enter= browser.buttons[0]

    #did_field.set("8565898822")
    did_field.set(did)
    #pin_field.set("7668603")
    pin_field.set(pin)
    enter.click
    return browser
  end

  def self.download_fax_zip_files
    fax_zip_file= nil
    browser= self.browse_fax_frame
    frame= browser.frame(:name,'content')
    num_faxes= frame.checkboxes.length-1
    if num_faxes > 0
      frame.checkbox(:value,"Check All").set

      zip_fax_link= nil
      frame.links.each{ |l| zip_fax_link = l  if /prepZipFax/.match( l.href ) }
      zip_fax_link.click
      dl_frame= browser.frame(:name,'content')

      sleep 1
      dl_frame.links[3].onclick

      sleep 1
      browser.back
      sleep 1

      frame= browser.frame(:name,'content')
      frame.checkbox(:value,"Check All").set

      save_fax_link= nil
      frame.links.each{ |l| save_fax_link = l  if /moveFax/.match( l.href ) }
      save_fax_link.click

    end
    return num_faxes
  end

  def self.get_download_fax_zip_filenames
    fax_zip_files= Dir.glob( ENV['DOWNLOADED_FAX_ZIP_GLOB'] )
    return fax_zip_files
  end

  def self.tmp_dir
    return File.join(Rails.root,'tmp','fax_extract')
  end

  def self.init_tmp_dir()
    %x[rm -r #{tmp_dir}] if File.exists?(tmp_dir)
    %x[mkdir #{tmp_dir}]
  end

  def self.pdf_fax_filenames(zfn)
    self.init_tmp_dir()
    %x(cd #{self.tmp_dir}; unzip #{zfn} )
    pdf_glob= File.join(self.tmp_dir,"**","*.fax.pdf")
    pdf_fns= Dir.glob( pdf_glob )
    return pdf_fns
  end

  def self.mv_to_faxes(fn)
    %x(mv #{fn} #{ENV['FAXES_DIR']} )
  end

end
