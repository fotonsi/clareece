class CajaCuadresController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :caja_cuadre do |config|
    config.list.label = "Cuadres de caja"
    config.create.label = "Crear cuadre"
    config.update.label = "Actualizar cuadre"
    config.create.link.page = config.update.link.page = true
    config.actions.exclude :show
    config.list.columns = [:fecha, :ingresos, :pagos, :saldo_caja, :total_detalle, :saldo, :cerrado]
    #config.create.columns = config.update.columns = [:cent_1, :cent_2, :cent_5, :cent_10, :cent_20, :cent_50, :eur_1, :eur_2, :eur_5, :eur_10, :eur_20, :eur_50, :eur_100, :eur_200, :eur_500, :total_movimientos, :total_caja]
    config.columns.add :descuadre
    config.columns.add :saldo_caja2
    config.columns[:descuadre].css_class = 'numeric'
    config.columns[:saldo_anterior].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:ingresos].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:suma_ingresos].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:pagos].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:ingresado_bancos].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:ingresado_datafono].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:suma_pagos].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:saldo_caja].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:efectivo].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:vales].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:cheques].options = {:size => 10, :alt => 'signed-decimal'}
    config.columns[:saldo_caja2].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:saldo_caja2].label = "Saldo caja"
    config.columns[:total_detalle].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.columns[:saldo].options = {:size => 10, :alt => 'signed-decimal', :readonly => true}
    config.list.sorting = [{:fecha => :desc}, {:id => :desc}]

    #New actions
    config.action_links.add 'informe',
      :action => 'informe',
      :type => :record,
      :inline => true,
      :position => false,
      :icon => {:image => "shared/informe.gif", :title => "Informe de arqueo"}
  end if CajaCuadre.table_exists?

  def informe
    redirect_to :controller => 'informes', :action => 'parsea', :id => Informe.find_by_objeto('caja_cuadre_calculado'), :objeto_id => params[:id]
  end

  def listar_ingresos
    if params[:id]
      cc = CajaCuadre.find(params[:id])
    elsif params[:fecha]
      cc = CajaCuadre.new
      cc.fecha params[:fecha].to_time
    end
    return unless cc
    send_data cc.listar_ingresos, :type => 'text/csv', :disposition => 'attachment', :filename => 'ingresos.csv'
  end

  def listar_pagos
    if params[:id]
      cc = CajaCuadre.find(params[:id])
    elsif params[:fecha]
      cc = CajaCuadre.new
      cc.fecha params[:fecha].to_time
    end
    return unless cc
    send_data cc.listar_pagos, :type => 'text/csv', :disposition => 'attachment', :filename => 'pagos.csv'
  end
end
