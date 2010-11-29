class Document::Fax

  def self.browse_accessline
     Browser.get_browser.goto("https://www.accessline.com/login.asp?nav=login")
  end

  def self.browse_fax_frame
    browser= self.browse_accessline
    did_field= browser.text_fields[1]
    pin_field= browser.text_fields[0]
    enter= browser.buttons[0]

    did_field.set("8565898822")
    pin_field.set("7668603")
    enter.click
    return browser
  end

  def self.download_fax_zip_file
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

      pdf_link= dl_frame.links[3]
      pdf_link.onclick

      browser.back

      save_fax_link= nil
      frame.links.each{ |l| save_fax_link = l  if /moveFax/.match( l.href ) }
      save_fax_link.click

    end
    return num_faxes
  end

  def self.get_download_fax_zip_filename
    fax_zip_files= Dir.glob( ENV['DOWNLOADED_FAX_ZIP_GLOB'] )
    if fax_zip_files.length == 0
      p "fax_zip_file not downloaded"
    elsif fax_zip_files.length > 1
      p "more than 1 fax_zip_file downloaded"
    else
      p "1 fax_zip_file downloaded"
      fax_zip_file= fax_zip_files[0]
      debugger
    end
    return fax_zip_file
  end

end
