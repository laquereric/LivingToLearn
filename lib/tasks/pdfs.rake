namespace :pdfs do

  desc "faxes"
  task :faxes  => :environment do
    p "Faxes:"
    dir= ENV['FAXES_DIR']
    cmd= 'ls' + ' ' + dir
    dir_list= %x(#{cmd})
    dir_list.split.each{ |fn|
      Document::Pdf.parse(dir+fn)
    }
  end

end

