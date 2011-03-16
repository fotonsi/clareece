class TipoProcedenciasController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :tipo_procedencia if TipoProcedencia.table_exists?
end
