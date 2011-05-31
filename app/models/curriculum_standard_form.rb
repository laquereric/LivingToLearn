class CurriculumStandardForm < Netzke::Basepack::FormPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::Standard',
      :record_id =>  ::Netzke::Core.controller.params[:id]
    })
  end

end

