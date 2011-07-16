module ApplicationHelper

  def self.titlize_page_ref(page_ref)
    m= page_ref.match(/(.*)#(.*)/)
    if m
      page_ref.gsub('#','_').titleize
    else
      page_ref
    end
  end

end
