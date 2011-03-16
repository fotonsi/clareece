module CursoCoordinadoresHelper
  def coordinador_id_form_column(record, input_name)
    coordinadores_actuales = record.curso.curso_coordinadores.map {|p| p.coordinador_id}
    options = Coordinador.find(:all).reject {|p| coordinadores_actuales.include?(p.id) }.map {|p| [p.nombre_completo, p.id]}
    nice_select input_name, Coordinador, record.coordinador_id, :options => options
  end

  def nif_column(record)
    record.coordinador.nif if record.coordinador
  end

  def nombre_completo_column(record)
    record.coordinador.nombre_completo if record.coordinador
  end
end
