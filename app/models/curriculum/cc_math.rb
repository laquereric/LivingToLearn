require 'csv'

class Curriculum::CcMath < Curriculum::CcParse

  # ID => K.RL.2
  # Category => Reading Literature
  # Sub Category => Key Ideas and Details
  # State Standard => With prompting and support, ask and answer questions about key details in a text.

  # :content_area               # CC_Reading
  # :standard                   # Category - Reading Literature
  # :strand                     # SubCategory - Key Ideas and Details
  # :content_statement          # (parsed from id)- by grade K

  # :cpi_num #(parsed from id) 2
  # :cumulative_progress_indicator #State Standard

###########
# Lower Level
###########

  def self.filename
    File.join(Rails.root,'data','CC_Standards_Math_6.25.10.csv')
  end

  def self.content_area_key
    'CC_Standards_Math'
  end

end

