class CurriculumContentAreasGrid < Netzke::Basepack::GridPanel

  def configuration
    content_area_id = ::Netzke::Core.controller.params[:content_area_id]
    c = super.merge({
      :class_name => "Basepack::GridPanel",
      :model => "Curriculum::ContentArea",
      :columns => [
         {:name => :code,:width => 100 },
         {:name => :name, :width => 300 },
         { :name => :description, :width => 300},
         {:name => :details,
           :header => "Details",
           :getter => lambda { |r|
             r.link_to_details
            }
          },
          {:name => :curriculum_standards__link_to,
           :header => "Standards",
           :getter => lambda { |r|
              r.link_to_standards
           }
         }
      ]
    })
  end

end

