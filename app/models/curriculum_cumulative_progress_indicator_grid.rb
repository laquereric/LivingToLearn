class CurriculumCumulativeProgressIndicatorGrid < Netzke::Basepack::GridPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::CumulativeProgressIndicator',
      :columns => [
        :id,
        {:name => :code, :width => 30 },
        {:name => :description, :width => 300 },
        {:name => :curriculum_content_statement__by_end_of_grade_clean, :width => 30, :header => "Grade", :width => 60 },
        {:name => :curriculum_content_statement__description, :width => 300 },
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

