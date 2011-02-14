namespace :doc_base do

  desc "push_from_inbox"
  task :push_from_inbox => :environment do
    Inbox.push_pdf_pages
  end

  desc "move to db"
  task :move_to_db => :environment do
    DocBase.all.each{ |d| d.save }
  end

end
