# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110309101258) do

  create_table "adjuntos", :force => true do |t|
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "db_file_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "parent_type"
    t.binary   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "saved_as"
  end

  add_index "adjuntos", ["db_file_id"], :name => "index_adjuntos_on_db_file_id"
  add_index "adjuntos", ["parent_id"], :name => "index_adjuntos_on_parent_id"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "aulas", :force => true do |t|
    t.string   "nombre"
    t.integer  "capacidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "localidad_id"
  end

  create_table "ausencias", :force => true do |t|
    t.string   "turno"
    t.integer  "alumno_id"
    t.integer  "curso_id"
    t.date     "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alumno_type"
  end

  add_index "ausencias", ["alumno_id"], :name => "index_ausencias_on_alumno_id"
  add_index "ausencias", ["curso_id"], :name => "index_ausencias_on_curso_id"

  create_table "bancos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cod_entidad"
  end

  create_table "caja_cuadres", :force => true do |t|
    t.integer  "cent_1"
    t.integer  "cent_2"
    t.integer  "cent_5"
    t.integer  "cent_10"
    t.integer  "cent_20"
    t.integer  "cent_50"
    t.integer  "eur_1"
    t.integer  "eur_2"
    t.integer  "eur_5"
    t.integer  "eur_10"
    t.integer  "eur_20"
    t.integer  "eur_50"
    t.integer  "eur_100"
    t.integer  "eur_200"
    t.integer  "eur_500"
    t.float    "saldo_caja"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha"
    t.float    "saldo_anterior"
    t.float    "ingresos"
    t.float    "suma_ingresos"
    t.float    "pagos"
    t.float    "ingresado_bancos"
    t.float    "ingresado_datafono"
    t.float    "suma_pagos"
    t.float    "efectivo"
    t.float    "vales"
    t.float    "cheques"
    t.float    "total_detalle"
    t.float    "saldo"
    t.text     "observaciones"
    t.boolean  "cerrado"
  end

  create_table "cajas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ubicacion"
    t.string   "nombre"
  end

  create_table "centros", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colegiado_especialidades", :force => true do |t|
    t.integer  "colegiado_id"
    t.integer  "especialidad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colegiado_especialidades", ["colegiado_id"], :name => "index_colegiado_especialidades_on_colegiado_id"
  add_index "colegiado_especialidades", ["especialidad_id"], :name => "index_colegiado_especialidades_on_especialidad_id"

  create_table "colegiado_profesiones", :force => true do |t|
    t.integer  "colegiado_id"
    t.integer  "profesion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colegiado_profesiones", ["colegiado_id"], :name => "index_colegiado_profesiones_on_colegiado_id"
  add_index "colegiado_profesiones", ["profesion_id"], :name => "index_colegiado_profesiones_on_profesion_id"

  create_table "colegiados", :force => true do |t|
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "doc_identidad"
    t.string   "direccion"
    t.string   "telefonos"
    t.string   "telefono_trabajo"
    t.string   "fax"
    t.string   "cc_aa"
    t.string   "email"
    t.string   "num_cuenta"
    t.string   "oficina"
    t.string   "nombre_titular_cuenta"
    t.string   "poblacion_banco"
    t.string   "type"
    t.string   "procedencia"
    t.string   "destino"
    t.string   "ref_historial"
    t.integer  "localidad_id"
    t.integer  "banco_id"
    t.integer  "profesion_id"
    t.integer  "num_colegiado"
    t.integer  "centro_id"
    t.date     "fecha_nacimiento"
    t.date     "fecha_cambio_domicilio"
    t.date     "fecha_ingreso"
    t.date     "fecha_baja"
    t.boolean  "no_ejerciente"
    t.boolean  "jubilado"
    t.string   "sexo",                           :limit => 1
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "localidad_nacimiento_id"
    t.string   "grado_carrera"
    t.string   "situacion_profesional"
    t.string   "ejercicio_profesional"
    t.boolean  "domiciliar_pagos"
    t.boolean  "saldar_deuda",                                 :default => false
    t.float    "importe_deuda",                                :default => 0.0
    t.string   "situacion_colegial"
    t.boolean  "exento_pago",                                  :default => false
    t.integer  "expediente_id"
    t.boolean  "titular_cuenta"
    t.string   "domicilio_titular_cuenta"
    t.string   "plaza_domicilio_titular_cuenta"
    t.string   "cp_titular_cuenta"
    t.text     "err_migracion"
    t.boolean  "sociedad_profesional"
    t.string   "tipo_doc_identidad"
    t.integer  "pais_id"
    t.boolean  "migrado"
    t.integer  "motivo_ingreso_id"
    t.integer  "motivo_baja_id"
    t.date     "fecha_ini_exencion_pago"
    t.date     "fecha_fin_exencion_pago"
    t.boolean  "revista"
    t.boolean  "eboletin"
    t.string   "cod_postal"
    t.string   "localidad"
    t.string   "localidad_nacimiento"
    t.integer  "pais_residencia_id"
    t.float    "deuda_a_saldar"
    t.string   "cuota_ingreso_forma_pago",       :limit => 20
  end

  add_index "colegiados", ["banco_id"], :name => "index_colegiados_on_banco_id"
  add_index "colegiados", ["centro_id"], :name => "index_colegiados_on_centro_id"
  add_index "colegiados", ["expediente_id"], :name => "index_colegiados_on_expediente_id"
  add_index "colegiados", ["localidad_id"], :name => "index_colegiados_on_localidad_id"
  add_index "colegiados", ["localidad_nacimiento_id"], :name => "index_colegiados_on_localidad_nacimiento_id"
  add_index "colegiados", ["num_colegiado"], :name => "index_colegiados_on_num_colegiado"
  add_index "colegiados", ["pais_id"], :name => "index_colegiados_on_pais_id"
  add_index "colegiados", ["profesion_id"], :name => "index_colegiados_on_profesion_id"

  create_table "colegios", :force => true do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "fax"
    t.string   "email"
    t.integer  "localidad_id"
    t.string   "entidad"
    t.string   "oficina"
    t.string   "dc"
    t.string   "cuenta"
    t.float    "recargo_bancario"
    t.integer  "dia_trans_deuda"
    t.boolean  "actual"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secretaria"
    t.string   "presidencia"
    t.string   "vicepresidencia"
    t.string   "tesoreria"
    t.string   "cif"
    t.string   "contabilidad_email"
    t.boolean  "propio"
    t.float    "cuota_colegiacion"
    t.integer  "cuota_colegiacion_num_plazos"
  end

  add_index "colegios", ["localidad_id"], :name => "index_colegios_on_localidad_id"

  create_table "coordinadores", :force => true do |t|
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "doc_identidad"
    t.string   "telefono"
    t.string   "movil"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "localidad_id"
    t.string   "num_cuenta",         :limit => 24
    t.string   "email"
    t.string   "tipo_doc_identidad"
  end

  create_table "curso_acreditaciones", :force => true do |t|
    t.integer  "entidad_acreditadora_id"
    t.integer  "curso_id"
    t.float    "creditos"
    t.date     "fecha_solicitud"
    t.date     "fecha_obtencion"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curso_coordinadores", :force => true do |t|
    t.integer  "curso_id"
    t.integer  "coordinador_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curso_horarios", :force => true do |t|
    t.integer "curso_id"
    t.date    "fecha_ini"
    t.date    "fecha_fin"
    t.string  "hora_ini",  :limit => 5
    t.string  "hora_fin",  :limit => 5
  end

  create_table "curso_profesores", :force => true do |t|
    t.integer  "curso_id"
    t.integer  "profesor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "curso_profesores", ["curso_id"], :name => "index_curso_profesores_on_curso_id"
  add_index "curso_profesores", ["profesor_id"], :name => "index_curso_profesores_on_profesor_id"

  create_table "cursos", :force => true do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.date     "fecha_ini"
    t.date     "fecha_fin"
    t.datetime "fecha_limite_matricula"
    t.datetime "fecha_limite_devolucion"
    t.text     "temario"
    t.text     "observaciones"
    t.float    "precio_matricula"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_plazas_max"
    t.integer  "num_plazas_min"
    t.string   "descripcion"
    t.string   "estado"
    t.integer  "porc_asistencia_minima"
    t.integer  "aula_id"
    t.datetime "fecha_inicio_matricula"
    t.float    "num_horas"
    t.float    "num_horas_presenciales"
    t.float    "num_horas_virtuales"
    t.integer  "num_plazas_presenciales"
  end

  add_index "cursos", ["aula_id"], :name => "index_cursos_on_aula_id"

  create_table "documentos", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entidades_acreditadoras", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_alias"
  end

  create_table "especialidades", :force => true do |t|
    t.string   "nombre"
    t.integer  "profesion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "especialidades", ["profesion_id"], :name => "index_especialidades_on_profesion_id"

  create_table "expediente_gestion_etiquetas", :force => true do |t|
    t.integer  "expediente_gestion_id"
    t.string   "etiqueta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expedientes", :force => true do |t|
    t.string   "titulo"
    t.text     "descripcion"
    t.date     "fecha_apertura"
    t.date     "fecha_cierre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo"
  end

  create_table "expedientes_expedientes", :id => false, :force => true do |t|
    t.integer  "expediente_id"
    t.integer  "expediente_relacion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expedientes_expedientes", ["expediente_id"], :name => "index_expedientes_expedientes_on_expediente_id"
  add_index "expedientes_expedientes", ["expediente_relacion_id"], :name => "index_expedientes_expedientes_on_expediente_relacion_id"

  create_table "expedientes_gestiones", :force => true do |t|
    t.integer  "expediente_id"
    t.integer  "gestion_documental_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expedientes_gestiones", ["expediente_id"], :name => "index_expedientes_gestiones_on_expediente_id"
  add_index "expedientes_gestiones", ["gestion_documental_id"], :name => "index_expedientes_gestiones_on_gestion_documental_id"

  create_table "externos", :force => true do |t|
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "nif"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "formaciones", :force => true do |t|
    t.integer  "alumno_id"
    t.string   "alumno_type"
    t.integer  "curso_id"
    t.string   "estado"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "nota"
    t.string   "forma_pago"
    t.boolean  "apto",          :default => true
  end

  add_index "formaciones", ["alumno_id", "alumno_type"], :name => "index_formaciones_on_alumno_id_and_alumno_type"
  add_index "formaciones", ["alumno_id"], :name => "index_formaciones_on_alumno_id"
  add_index "formaciones", ["alumno_type"], :name => "index_formaciones_on_alumno_type"
  add_index "formaciones", ["curso_id"], :name => "index_formaciones_on_curso_id"

  create_table "gestiones_documentales", :force => true do |t|
    t.string   "tipo"
    t.string   "responsable"
    t.string   "destinatario"
    t.string   "nombre_documento"
    t.text     "observaciones"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "texto"
    t.integer  "num_registro"
    t.string   "remitente"
    t.text     "direccion_remitente"
    t.text     "direccion_destinatario"
  end

  add_index "gestiones_documentales", ["documento_id"], :name => "index_gestiones_documentales_on_documento_id"

  create_table "informes", :force => true do |t|
    t.string   "objeto"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "width"
    t.integer  "height"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre"
    t.boolean  "registro"
  end

  create_table "localidades", :force => true do |t|
    t.string   "nombre"
    t.string   "cp"
    t.integer  "provincia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "localidades", ["provincia_id"], :name => "index_localidades_on_provincia_id"

  create_table "movimientos", :force => true do |t|
    t.integer  "caja_id"
    t.float    "importe"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "titular_id"
    t.string   "titular_type"
    t.integer  "origen_id"
    t.string   "origen_type"
    t.string   "concepto"
    t.string   "forma_pago"
    t.string   "concepto_de"
    t.datetime "fecha"
    t.string   "a_favor_de"
    t.datetime "fecha_anulacion"
    t.datetime "fecha_devolucion"
    t.integer  "devolucion_de_id"
  end

  add_index "movimientos", ["caja_id"], :name => "index_movimientos_on_caja_id"
  add_index "movimientos", ["origen_id", "origen_type"], :name => "index_movimientos_on_origen_id_and_origen_type"
  add_index "movimientos", ["origen_id"], :name => "index_movimientos_on_origen_id"
  add_index "movimientos", ["origen_type"], :name => "index_movimientos_on_origen_type"
  add_index "movimientos", ["titular_id", "titular_type"], :name => "index_movimientos_on_titular_id_and_titular_type"
  add_index "movimientos", ["titular_id"], :name => "index_movimientos_on_titular_id"
  add_index "movimientos", ["titular_type"], :name => "index_movimientos_on_titular_type"

  create_table "notas", :force => true do |t|
    t.integer  "origen_id"
    t.string   "origen_type"
    t.string   "autor"
    t.text     "texto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notas", ["origen_id", "origen_type"], :name => "index_notas_on_origen_id_and_origen_type"
  add_index "notas", ["origen_id"], :name => "index_notas_on_origen_id"
  add_index "notas", ["origen_type"], :name => "index_notas_on_origen_type"

  create_table "paises", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permisos", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permisos_roles", :id => false, :force => true do |t|
    t.integer "permiso_id"
    t.integer "rol_id"
  end

  create_table "plugin_schema_migrations", :force => true do |t|
    t.string "plugin_name"
    t.string "version"
  end

  create_table "profesiones", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profesores", :force => true do |t|
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "doc_identidad"
    t.string   "telefono"
    t.string   "movil"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "localidad_id"
    t.string   "num_cuenta",         :limit => 24
    t.string   "email"
    t.string   "tipo_doc_identidad"
  end

  create_table "provincias", :force => true do |t|
    t.string   "nombre"
    t.integer  "pais_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provincias", ["pais_id"], :name => "index_provincias_on_pais_id"

  create_table "recibos", :force => true do |t|
    t.string   "concepto"
    t.string   "concepto1"
    t.string   "concepto2"
    t.string   "concepto3"
    t.string   "concepto4"
    t.string   "concepto5"
    t.string   "concepto6"
    t.float    "importe"
    t.float    "importe1"
    t.float    "importe2"
    t.float    "importe3"
    t.float    "importe4"
    t.float    "importe5"
    t.float    "importe6"
    t.float    "importe_total"
    t.string   "concepto_de"
    t.string   "concepto_de1"
    t.string   "concepto_de2"
    t.string   "concepto_de3"
    t.string   "concepto_de4"
    t.string   "concepto_de5"
    t.string   "concepto_de6"
    t.integer  "remesa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "titular_id"
    t.string   "titular_type"
    t.string   "estado"
  end

  add_index "recibos", ["remesa_id"], :name => "index_recibos_on_remesa_id"
  add_index "recibos", ["titular_id", "titular_type"], :name => "index_recibos_on_titular_id_and_titular_type"
  add_index "recibos", ["titular_id"], :name => "index_recibos_on_titular_id"
  add_index "recibos", ["titular_type"], :name => "index_recibos_on_titular_type"

  create_table "remesas", :force => true do |t|
    t.string   "concepto"
    t.string   "concepto1"
    t.string   "concepto2"
    t.string   "concepto3"
    t.string   "concepto4"
    t.string   "concepto5"
    t.string   "concepto6"
    t.float    "importe"
    t.float    "importe1"
    t.float    "importe2"
    t.float    "importe3"
    t.float    "importe4"
    t.float    "importe5"
    t.float    "importe6"
    t.float    "importe_total"
    t.string   "concepto_de"
    t.string   "concepto_de1"
    t.string   "concepto_de2"
    t.string   "concepto_de3"
    t.string   "concepto_de4"
    t.string   "concepto_de5"
    t.string   "concepto_de6"
    t.string   "estado"
    t.string   "tipo"
    t.date     "fecha_cobro"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fichero_bancario_id"
    t.date     "fecha_generacion"
    t.date     "fecha_entrega"
    t.date     "fecha_anulacion"
  end

  create_table "roles", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_usuarios", :id => false, :force => true do |t|
    t.integer "rol_id"
    t.integer "usuario_id"
  end

  create_table "sessiones", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessiones", ["session_id"], :name => "index_sessiones_on_session_id"
  add_index "sessiones", ["updated_at"], :name => "index_sessiones_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tipo_destinos", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_procedencias", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titulos", :force => true do |t|
    t.integer  "formacion_id"
    t.datetime "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gestion_documental_id"
  end

  create_table "transacciones", :force => true do |t|
    t.string   "concepto"
    t.text     "observaciones"
    t.float    "importe"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "destinatarios"
    t.string   "concepto_de"
    t.date     "fecha_cobro"
    t.date     "fecha_generacion"
    t.boolean  "generado"
    t.string   "forma_pago"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "login"
    t.string   "nombre"
    t.string   "apellido1"
    t.string   "apellido2"
    t.string   "rol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "origen_type"
    t.integer  "origen_id"
    t.string   "password"
  end

end
