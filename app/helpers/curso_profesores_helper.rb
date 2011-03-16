module CursoProfesoresHelper
  def profesor_id_form_column(record, input_name)
    profesores_actuales = record.curso.curso_profesores.map {|p| p.profesor_id}
    options = Profesor.find(:all).reject {|p| profesores_actuales.include?(p.id) }.map {|p| [p.nombre_completo, p.id]}
    nice_select input_name, Profesor, record.profesor_id, :options => options
  end

  def nif_column(record)
    record.profesor.doc_identidad if record.profesor
  end

  def nombre_completo_column(record)
    record.profesor.nombre_completo if record.profesor
  end
end
