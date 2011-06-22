module MenuOptions
  TOTAL = [
    {:label => "#{OBJETO_PRINCIPAL.capitalize.pluralize}", :image => "menu/colegiados.png", 
      :submenu => [
        {:label => 'Mis datos', :url => {:controller => "colegiados", :action => "mis_datos"}},
        {:label => 'Listado', :url => {:controller => "colegiados", :action => "index"}},
        {:label => "Nuevo #{OBJETO_PRINCIPAL}", :url => {:controller => "colegiados", :action => "new"}}
      ] 
    }, 
    {:label => 'Expedientes', :image => "menu/expedientes.png", 
      :submenu => [
        {:label => 'Listado', :url => {:controller => "expedientes", :action => "index"}},
        {:label => 'Nuevo expediente', :url => {:controller => "expedientes", :action => "new"}}
      ] 
    },
    {:label => 'Cursos', :image => "menu/cursos.png",
      :submenu => [
        {:label => 'Listado', :url => {:controller => 'cursos', :action => 'index'}},
        {:label => 'Nuevo curso', :url => {:controller => 'cursos', :action => 'new'}},
        {:label => '----------',  :url => {}},
        {:label => 'Profesores', :url => {:controller => 'profesores', :action => 'index'}},
        {:label => 'Coordinadores', :url => {:controller => 'coordinadores', :action => 'index'}},
        {:label => 'Aulas', :url => {:controller => 'aulas', :action => 'index'}}
      ]
    },
    {:label => 'Entrada/salida', :image => "menu/gestion_doc.png",
      :submenu => [
        {:label => 'Listado', :url => {:controller => 'gestiones_documentales'}},
        {:label => 'Comunicación', :url => {:controller => 'comunicaciones'}}
      ]
    },
    {:label => 'Facturación', :image => "shared/remesas.png",
      :submenu => [
        {:label => 'Remesas', :url => {:controller => 'remesas', :action => 'index'}},
        {:label => 'Transacciones', :url => {:controller => 'transacciones', :action => 'index'}},
        {:label => 'Movimientos', :url => {:controller => 'movimientos', :action => 'index'}},
        {:label => 'Cuadres de caja', :url => {:controller => 'caja_cuadres', :action => 'index'}}
      ]
    },
    {:label => 'Configuración', :image => "menu/conf.png", 
      :submenu => [
        #{:label => 'Datos del colegio', :url => {:controller => 'colegios', :action => 'edit', :id => (Colegio.actual)}},
        {:label => "#{TIPO_OBJETO.pluralize.capitalize}",  :url => {:controller => 'colegios', :action => 'index'}},
        {:label => '----------',  :url => {}},
        {:label => 'Usuarios',  :url => {:controller => 'usuarios', :action => 'index'}},
        {:label => 'Roles',  :url => {:controller => 'roles', :action => 'index'}},
        {:label => 'Permisos',  :url => {:controller => 'permisos', :action => 'index'}},
      ]
    },
    {:label => 'Mantenimiento', :image => "menu/mantenimiento.png", 
      :submenu =>
      [
        {:label => 'Paises',  :url => {:controller => 'paises', :action => 'index'}},
        {:label => 'Provincias',  :url => {:controller => 'provincias', :action => 'index'}},
        {:label => 'Localidades',  :url => {:controller => 'localidades', :action => 'index'}},
        {:label => '----------',  :url => {}},
        {:label => 'Bancos',  :url => {:controller => 'bancos', :action => 'index'}},
        {:label => 'Centros',  :url => {:controller => 'centros', :action => 'index'}},
        {:label => 'Profesiones',  :url => {:controller => 'profesiones', :action => 'index'}},
        {:label => 'Especialidades',  :url => {:controller => 'especialidades', :action => 'index'}},
        {:label => '----------',  :url => {}},
        {:label => 'Informes',  :url => {:controller => 'informes', :action => 'index'}},
      ]
    }
  ]

end
