class MailMerge

  def self.tmp_list_filename
    return File.join(RAILS_ROOT,'tmp','mail_merge','list.csv')
  end

  def self.tmp_merged_dir
    return File.join(RAILS_ROOT,'tmp','mail_merge','merged')
  end

  def self.tmp_letter_filename
    return File.join(RAILS_ROOT,'tmp','mail_merge','letter.odt')
  end

  def self.letter_filename(letter_name)
    return File.join(RAILS_ROOT,'open_office',"letter_#{letter_name}.odt")
  end

  def self.get_letter(letter_name)
    self.clear_letter
    self.clear_merged
    %x[cp -f #{self.letter_filename(letter_name)}  #{self.tmp_letter_filename}]
  end

  def self.clear_letter
    %x[rm -f  #{ self.tmp_letter_filename}]
  end

  def self.clear_merged
    %x[rm -rf  #{ self.tmp_merged_dir }]
  end

  def self.swriter_letter(letter_name)
    self.get_letter(letter_name)
    %x[swriter #{self.tmp_letter_filename}]
  end

  def self.swriter_letter_ses_administrators_intro()
    self.swriter_letter('ses_administrators_intro')
  end

end
