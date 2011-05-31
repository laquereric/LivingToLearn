class CurriculumStandardsGrid < Netzke::Basepack::GridPanel

  def configuration
    c = super.merge({
      :class_name => "Basepack::GridPanel",
      :model => "Curriculum::Standard",
      :columns => [:id,
        {:name=>:code,:width=>30},
        {:name=>:name,:width=>300},
        {:name=>:description,:width=>300},
        {:name => :curriculum_content_area__link_to,
          :header => "Content Area",
          :getter => lambda { |r|
            r.link_to_content_area
          }
        }
      ]
    })
  end

end

