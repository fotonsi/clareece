#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../config/boot'
require "#{RAILS_ROOT}/config/environment"
require 'faker'

bancos = Banco.all.map(&:id)
centros = Centro.all.map(&:id)

Profesion.create!(:nombre => 'Titulado en algo') if Profesion.count == 0
Pais.create!(:nombre => 'España') if Pais.count == 0

(1..99).each do |num_c|
  doc_id = rand(100000000)
  doc_id = "#{doc_id}#{"TRWAGMYFPDXBNJZSQVHLCKE"[doc_id % 23].chr}"

  attrs = {
    "apellido1"                      => Faker::Name.last_name,
    "apellido2"                      => Faker::Name.last_name,
    "banco_id"                       => bancos[1+rand(bancos.size)],
    "cc_aa"                          => nil,
    "centro_id"                      => centros[1+rand(centros.size)],
    "cod_postal"                     => 1+rand(40000),
    "cp_titular_cuenta"              => 1+rand(40000),
    "cuota_ingreso_forma_pago"       => 'domiciliacion',
    "destino"                        => nil,
    "deuda_a_saldar"                 => nil,
    "direccion"                      => Faker::Address.street_name+' '+Faker::Address.street_suffix,
    "doc_identidad"                  => doc_id,
    "domiciliar_pagos"               => true,
    "domicilio_titular_cuenta"       => nil,
    "eboletin"                       => nil,
    "ejercicio_profesional"          => nil,
    "email"                          => Faker::Internet::email,
    "err_migracion"                  => nil,
    "exento_pago"                    => nil,
    "expediente_id"                  => nil,
    "fax"                            => 1+rand(999999999),
    "fecha_baja"                     => nil,
    "fecha_cambio_domicilio"         => nil,
    "fecha_fin_exencion_pago"        => nil,
    "fecha_ingreso"                  => '1900-01-01'.to_date+rand(40000),
    "fecha_ini_exencion_pago"        => nil,
    "fecha_nacimiento"               => '1900-01-01'.to_date+rand(40000),
    "grado_carrera"                  => nil,
    "importe_deuda"                  => nil,
    "jubilado"                       => nil,
    "localidad"                      => Faker::Address.city,
    "localidad_id"                   => nil,
    "localidad_nacimiento"           => Faker::Address.city,
    "localidad_nacimiento_id"        => nil,
    "migrado"                        => nil,
    "motivo_baja_id"                 => nil,
    "motivo_ingreso_id"              => TipoProcedencia.find_by_nombre('nuevo_ingreso'),
    "no_ejerciente"                  => nil,
    "nombre"                         => Faker::Name.name,
    "nombre_titular_cuenta"          => nil,
    "num_colegiado"                  => num_c,
    "num_cuenta"                     => '21003606002100256574',
    "observaciones"                  => Faker::Lorem.paragraph,
    "oficina"                        => nil,
    "pais_id"                        => Pais.first,
    "pais_residencia_id"             => Pais.first,
    "plaza_domicilio_titular_cuenta" => nil,
    "poblacion_banco"                => Faker::Address.city,
    "procedencia"                    => nil,
    "profesion_id"                   => nil,
    "ref_historial"                  => nil,
    "revista"                        => nil,
    "saldar_deuda"                   => nil,
    "sexo"                           => ['H', 'M'][rand(2)],
    "situacion_colegial"             => 'colegiado',
    "situacion_profesional"          => nil,
    "sociedad_profesional"           => nil,
    "telefono_trabajo"               => 1+rand(999999999),
    "telefonos"                      => [(1+rand(999999999)), (1+rand(699999999))].join(','),
    "tipo_doc_identidad"             => 'nif',
    "titular_cuenta"                 => nil,
  }
  begin
    Colegiado.transaction do
      doc = Documento.new
      doc.tag_list.add('solicitud_alta', 'documento_identidad', 'titulo_profesional')
      gd = GestionDocumental.new(:tipo => 'entrada', :remitente => 'Colegiado', :texto => 'Documentos de alta para el expediente')
      gd.documento = doc
      gd.save!
      col = Colegiado.new(attrs)
      col.colegiado_profesiones << ColegiadoProfesion.new(:profesion_id => Profesion.first)
      col.expediente = Expediente.new(:titulo => "Expediente del colegiado #{num_c}", :tipo =>'colegiado', :fecha_apertura => Time.now)
      col.expediente.gestiones_documentales << gd
      col.save!
    end
  rescue
    next
  end
end
