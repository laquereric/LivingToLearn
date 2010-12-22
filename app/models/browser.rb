require 'rubygems'
class Browser
  cattr_accessor :browser

  def self.get_browser
    return self.browser if !self.browser.nil?
    process_info_array= firefox_process= %x(ps auxwww | awk /firefox-bin/).split
    if process_info_array.length>30 then
      firefox_process= process_info_array[1]
      %x( kill #{firefox_process} )
    end
    sleep 4
    system "sh #{RAILS_ROOT}/lib/start_firefox_jssh.exe"
    sleep 4
    browser = FireWatir::Firefox.new
    return browser
  end

end
