class CurriculumContentStatementsGrid < Netzke::Basepack::GridPanel

  def configuration
    config = {
      :model => 'Curriculum::ContentStatement',
      :columns => [
        :id,
        {:name => :description,:width=>300},
        {:name => :by_end_of_grade,:header => "Grade"},
        {:name => :details,
          :header => "Details",
          :getter => lambda { |r|
            r.link_to_details
          }
        },
        {:name => :curriculum_strand__link_to,
          :header => "Strand",
          :getter => lambda { |r|
            r.link_to_strand
          }
        },
        {:name => :cumulative_progress_indicators__children,
           :header => "Children",
           :getter => lambda { |r|
              r.cumulative_progress_indicators.count
           }
         },
         {:name => :cumulative_progress_indicators__link_to,
           :header => "Cumulative Progress Indicators",
           :getter => lambda { |r|
              r.link_to_cumulative_progress_indicators
           }
         }
      ]
    }
    if ( strand_id = ::Netzke::Core.controller.params[:strand_id] )
      config[:scope] =
        lambda { |r|
            r.where("curriculum_strand_id = #{strand_id.to_i}")
        }
    end
    c = super.merge(config)
  end

end

