class CurriculumStrandsGrid < Netzke::Basepack::GridPanel

  def configuration
    standard_id = ::Netzke::Core.controller.params[:standard_id].to_i
    c = super.merge({
      :model => 'Curriculum::Strand',
      :scope =>
        if standard_id then
          lambda { |r|
            r.where("curriculum_standard_id = #{standard_id}")
          }
        else
          nil
        end,
      :columns => [
        :id,
        {:name => :code, :width => 30 },
        {:name => :name, :width => 300 },
        {:name => :curriculum_standard__link_to,
          :header => "Standard",
          :getter => lambda { |r|
            r.link_to_standard
          }
        },
        {:name => :curriculum_content_statements__children,
           :header => "Children",
           :getter => lambda { |r|
              r.curriculum_content_statements.count
           }
        },
        {:name => :curriculum_content_statements__link_to,
           :header => "Content Statements",
           :getter => lambda { |r|
              r.link_to_content_statements
           }
         }
      ]
    })
  end

end

