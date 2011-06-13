module DocumentFilesBase

  def base_physical_directory
    dn = File.join(Rails.root,'public','images')
    %x{ mkdir -p #{dn} }
    return dn
  end

  def base_public_directory
    File.join('/','images')
  end

  def filename_base
    "no_filename_base"
  end

  def physical_directory
    dn = File.join(self.base_physical_directory,self.filename_base )
    %x{ mkdir -p #{dn} }
    return dn
  end

  def public_directory
    File.join(self.base_public_directory,self.filename_base)
  end

end

