class CurriculumStrandsGrid < Netzke::Basepack::GridPanel

  def configuration
    config = {
      :model => 'Curriculum::Strand',
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
    }
    if (standard_id = ::Netzke::Core.controller.params[:standard_id]) then
      config[:scope] =
          lambda { |r|
            r.where("curriculum_standard_id = #{standard_id.to_i}")
          }
    end
    c = super.merge(config)
  end

end

