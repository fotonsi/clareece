class BancosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :banco do |config|
  	config.columns.exclude :colegiados
        config.columns.exclude :created_at, :updated_at
  end if Banco.table_exists?
end
