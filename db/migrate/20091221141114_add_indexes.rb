class AddIndexes < ActiveRecord::Migration
  def self.up
    # ausencias
    add_index :ausencias, :alumno_id 
    add_index :ausencias, :curso_id
    # adjuntos
    add_index :adjuntos, :db_file_id
    add_index :adjuntos, :parent_id
    # colegiado_especialidades
    add_index :colegiado_especialidades, :colegiado_id
    add_index :colegiado_especialidades, :especialidad_id
    # colegiado_profesiones
    add_index :colegiado_profesiones, :colegiado_id 
    add_index :colegiado_profesiones, :profesion_id
    # colegiados
    add_index :colegiados, :localidad_id 
    add_index :colegiados, :banco_id
    add_index :colegiados, :profesion_id
    add_index :colegiados, :centro_id
    add_index :colegiados, :localidad_nacimiento_id
    add_index :colegiados, :expediente_id
    add_index :colegiados, :pais_id
    add_index :colegiados, :num_colegiado
    # colegios
    add_index :colegios, :localidad_id  
    # curso_profesores
    add_index :curso_profesores, :curso_id
    add_index :curso_profesores, :profesor_id
    # cursos
    add_index :cursos, :aula_id
    # especialidades
    add_index :especialidades, :profesion_id
    # expedientes_expedientes
    add_index :expedientes_expedientes, :expediente_id
    add_index :expedientes_expedientes, :expediente_relacion_id
    # expedientes_gestiones
    add_index :expedientes_gestiones, :expediente_id 
    add_index :expedientes_gestiones, :gestion_documental_id
    # formaciones
    add_index :formaciones, [:alumno_id, :alumno_type] 
    add_index :formaciones, :alumno_id
    add_index :formaciones, :alumno_type
    add_index :formaciones, :curso_id
    # gestiones_documentales
    add_index :gestiones_documentales, :documento_id
    # localidades
    add_index :localidades, :provincia_id
    # movimientos
    add_index :movimientos, :caja_id 
    add_index :movimientos, [:titular_id, :titular_type]
    add_index :movimientos, :titular_id
    add_index :movimientos, :titular_type 
    add_index :movimientos, [:origen_id, :origen_type]
    add_index :movimientos, :origen_id
    add_index :movimientos, :origen_type 
    # notas
    add_index :notas, [:origen_id, :origen_type]
    add_index :notas, :origen_id
    add_index :notas, :origen_type 
    # provincias
    add_index :provincias, :pais_id
    # recibos
    add_index :recibos, :remesa_id
  end

  def self.down
    remove_index :recibos, :column => :remesa_id
    # recibos
    remove_index :provincias, :column => :pais_id
    # provincias
    remove_index :notas, :column => :origen_type
    remove_index :notas, :column => :origen_id
    remove_index :notas, :column => [:origen_id, :origen_type]
    # notas
    remove_index :movimientos, :column => :origen_type
    remove_index :movimientos, :column => :origen_id
    remove_index :movimientos, :column => [:origen_id, :origen_type]
    remove_index :movimientos, :column => :titular_type
    remove_index :movimientos, :column => :titular_id
    remove_index :movimientos, :column => [:titular_id, :titular_type]
    remove_index :movimientos, :column => :caja_id
    # movimientos
    remove_index :localidades, :column => :provincia_id
    # localidades
    remove_index :gestiones_documentales, :column => :documento_id
    # gestiones_documentales
    remove_index :formaciones, :column => :curso_id
    remove_index :formaciones, :column => :alumno_type
    remove_index :formaciones, :column => :alumno_id
    remove_index :formaciones, :column => [:alumno_id, :alumno_type]
    # formaciones
    remove_index :expedientes_gestiones, :column => :gestion_documental_id
    remove_index :expedientes_gestiones, :column => :expediente_id
    # expedientes_gestiones
    remove_index :expedientes_expedientes, :column => :expediente_relacion_id
    remove_index :expedientes_expedientes, :column => :expediente_id
    # expedientes_expedientes
    remove_index :especialidades, :column => :profesion_id
    # especialidades
    remove_index :cursos, :column => :aula_id
    # cursos
    remove_index :curso_profesores, :column => :profesor_id
    remove_index :curso_profesores, :column => :curso_id
    # curso_profesores
    remove_index :colegios, :column => :localidad_id
    # colegios
    remove_index :colegiados, :column => :num_colegiado
    remove_index :colegiados, :column => :pais_id
    remove_index :colegiados, :column => :expediente_id
    remove_index :colegiados, :column => :localidad_nacimiento_id
    remove_index :colegiados, :column => :centro_id
    remove_index :colegiados, :column => :profesion_id
    remove_index :colegiados, :column => :banco_id
    remove_index :colegiados, :column => :localidad_id
    # colegiados
    remove_index :colegiado_profesiones, :column => :profesion_id
    remove_index :colegiado_profesiones, :column => :colegiado_id
    # colegiado_profesiones
    remove_index :colegiado_especialidades, :column => :especialidad_id
    remove_index :colegiado_especialidades, :column => :colegiado_id
    # colegiado_especialidades
    remove_index :adjuntos, :column => :parent_id
    remove_index :adjuntos, :column => :db_file_id
    # adjuntos
    remove_index :ausencias, :column => :curso_id
    remove_index :ausencias, :column => :alumno_id
    # ausencias
  end
end
