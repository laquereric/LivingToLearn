class Curriculum::Standard < ActiveRecord::Base
  set_table_name :curriculum_standards
  has_one :curriculum_item, :as => "target_node_object"
  include CurriculumContent

  belongs_to :curriculum_content_area,
    :class_name => 'Curriculum::ContentArea',
    :foreign_key => "curriculum_content_area_id"

  has_many :curriculum_strands,
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_standard_id",
    :dependent => :destroy

  def curriculum_strands_sorted_by_name
    self.curriculum_strands.sort{ |x,y|
        x.name <=> y.name
    }
  end

  def curriculum_strands_sorted_by_code
    self.curriculum_strands.sort{ |x,y|
        x.code <=> y.code
    }
  end

  def find_or_create_strand( strand_config )
     strands = self.curriculum_strands.select{ |strand|
       strand.name == strand_config[:name]
     }
     strand = if strands.length == 0
       p "new strand for #{self.id} : #{strand_config.inspect}"
       self.curriculum_strands<< (n = Curriculum::Strand.create(strand_config) )
       n
     elsif  strands.length == 1
       strands[0]
     else
       p "Duplicate Curriculum::Strand found #{strand_config[:name]}"
       nil
     end
  end

#######
#
#######
  include ReportLine

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_standards/#{self.id}"
  end

  def link_to_content_area
    self.link_to 'link',"/curriculum_content_areas/#{self.curriculum_content_area.id}"
  end

  def link_to_strands
    self.link_to 'link',"/curriculum_strands_for/#{self.id}"
  end

################
#
################

  def destroy_wrapper
    p "destroying Curriculum Standard #{self.code}"
    self.curriculum_strands.each{ |cs|
      cs.destroy_wrapper
    }
    self.destroy
  end

end
