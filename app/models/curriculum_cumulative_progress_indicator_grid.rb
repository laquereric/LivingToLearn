class CurriculumCumulativeProgressIndicatorGrid < Netzke::Basepack::GridPanel

  def configuration
    content_statement_id = ::Netzke::Core.controller.params[:content_statement_id].to_i
    c = super.merge({
      :model => 'Curriculum::CumulativeProgressIndicator',
      :scope =>
        if content_statement_id then
          lambda { |r|
            r.where("curriculum_content_statement_id = #{content_statement_id}")
          }
        else
          nil
        end,
      :columns => [
        :id,
        {:name => :code, :width => 30 },
        {:name => :curriculum_content_statement__by_end_of_grade_clean, :width => 30, :header => "Grade", :width => 60 },
        {:name => :curriculum_content_statement__description, :width => 300 },
        {:name => :description, :width => 300 },
        {:name => :curriculum_content_statement__link_to,
          :header => "Content Statement",
          :getter => lambda { |r|
            r.link_to_curriculum_content_statement
          }
        }
      ]
    })
  end

end

