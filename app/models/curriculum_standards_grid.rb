class CurriculumStandardsGrid < Netzke::Basepack::GridPanel

  def configuration
    content_area_id = ::Netzke::Core.controller.params[:content_area_id].to_i
    c = super.merge({
      :class_name => "Basepack::GridPanel",
      :model => "Curriculum::Standard",
      :scope =>
        if content_area_id then
          lambda { |r|
            r.where("curriculum_content_area_id = #{content_area_id}")
          }
        else
          nil
        end,
      :columns => [:id,
        {:name=>:code,:width=>30},
        {:name=>:name,:width=>300},
        {:name => :curriculum_content_area__link_to,
          :header => "Content Area",
          :getter => lambda { |r|
            r.link_to_content_area
          }
        },
        {:name => :curriculum_strands__link_to,
           :header => "Strands",
           :getter => lambda { |r|
              r.link_to_strands
           }
        }
      ]
    })
  end

end

