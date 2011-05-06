#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../config/boot'
require "#{RAILS_ROOT}/config/environment"

ultimo_num_colegiado = Colegiado.count
Colegiado.connection.execute("create sequence num_colegiado_seq minvalue #{(ultimo_num_colegiado || 0) + 1};") rescue 'Secuencia "num_colegiado_seq" parece que ya existe'
Colegiado.connection.execute("alter table colegiados alter column num_colegiado set default nextval('num_colegiado_seq');")

ult_registro_entrada = GestionDocumental.find(:all, :order => 'num_registro', :conditions => ['tipo = ?', 'entrada']).last.num_registro rescue 0
GestionDocumental.connection.execute("create sequence registro_entrada_seq minvalue #{(ult_registro_entrada || 0) + 1};")

ult_registro_salida = GestionDocumental.find(:all, :order => 'num_registro', :conditions => ['tipo = ?', 'salida']).last.num_registro rescue 0
GestionDocumental.connection.execute("create sequence registro_salida_seq minvalue #{(ult_registro_salida || 0) + 1};")
