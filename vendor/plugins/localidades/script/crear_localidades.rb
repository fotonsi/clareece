#!/usr/bin/ruby
require "#{File.dirname(__FILE__)}/../../../../config/environment"


# Script para generar provincias y localidades a partir de un fichero pasado por parametro.
# El fichero debe tener la estructura 
#      provincina | localidad | cp
#
# Se crean las provincias y se genera un fichero sql para crear las localidades (db/crear_localidades.sql).
#


unless pais = Pais.find_by_nombre("España")
  pais = Pais.create(:nombre => "España")
end

cont_prov = 0
cont_loc = 0

out = File.open("db/crear_localidades.sql", "w")

File.open(ARGV[0]) {|f|
  f.readlines.each{|line|
    # [provincia, localidad, cp]
    valores = line.split('|').map{|i| i.strip}
      
    unless provincia = Provincia.find_by_nombre(valores[0])
      provincia = Provincia.create(:nombre => valores[0], :pais_id => pais.id)
      cont_prov += 1
    end

    out.puts %|INSERT INTO localidades (nombre, cp, provincia_id) VALUES ('#{valores[1]}', #{valores[2]}, #{provincia.id});\n|

    print "\rProvincias:#{cont_prov}\tLocalidades:#{cont_loc += 1}\033[K"
    STDOUT.flush
  }
}

puts "\n"
out.close
