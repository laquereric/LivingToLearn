namespace :doc_base do

  desc "push_from_inbox"
  task :push_from_inbox => :environment do
    Inbox.push_pdf_pages
  end

end
