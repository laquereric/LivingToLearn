class CurriculumContentAreaForm < Netzke::Basepack::FormPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::ContentArea',
      :record_id =>  ::Netzke::Core.controller.params[:id]
    })
  end

end

