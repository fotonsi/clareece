class NotasController < ApplicationController
  include Authentication
  before_filter :access_authorized?

  active_scaffold :nota do |config|
    # General
    config.actions.exclude :show, :search
    config.columns[:texto].options = {:cols => 40, :rows => 6}
    form_columns = [:autor, :texto]

    # List
    config.list.columns = [:autor, :texto, :created_at]
    
    # Create
    config.create.label = "notas.create_label"
    config.create.link.inline = true
    config.create.columns = form_columns

    # Update
    config.update.label = "notas.update_label"
    config.update.link.inline = true
    config.update.columns = form_columns
  end if Nota.table_exists?

end
