module SelectOptionsHelper

  def situaciones_profesionales_for_select
    Colegiado::SITUACIONES_PROFESIONALES.map{|k,v| [v,k]}
  end

  def tipos_periodo_for_select
    Cuota::TIPOS_PERIODO.map{|i| [I18n.t("view.cuota.period.#{i}"), i]}
  end

  def recibo_estados_for_select
    Recibo::ESTADOS.map{|i| [I18n.t("view.recibo.estado.#{i}"), i.to_s]}
  end

end
