class CursoAlumno < ActiveRecord::Base
  set_table_name :cursos_alumnos
  def num_horas_letra
    require 'number_to_words'
    num_horas.to_words
  end

  def fecha_titulo
    meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    f = self.attributes['fecha_titulo']
    f.strftime("%d de #{meses[f.mon]} de %Y")
  end
end
