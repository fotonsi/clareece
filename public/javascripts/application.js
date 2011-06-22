// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function disableEnter(element_id){
    var element = $(element_id)
    Event.observe(element, "keypress", function(event)
    {
        if((event.target.tagName.toLowerCase() == "select" || (event.target.tagName.toLowerCase() == "input" && event.target.type.toLowerCase() != "button" && event.target.type.toLowerCase() != "submit")) && event.keyCode == Event.KEY_RETURN)
        {
            Event.stop(event);

            /* Buscamos el siguiente elemento */
            if(event.target.form && event.target.form.elements) {
                var found = false;
                $A(event.target.form.elements).each(function(element) {
                    if(element.getStyle("display") == "none" || element.disabled)
                        return;
                    if(found) {
                        element.focus();
                        throw $break;
                    } else if(event.target == element) {
                        found = true;
                    }
                });
            }
        }

    });
}

function confirm_disable_buttons(message, buttons_id, loading_indicator) {
  if (confirm(message)) {
    $(buttons_id).hide();
    $(loading_indicator).style.visibility = 'visible';
    return true;
  } else {
    return false;
  }
}

function setFieldMode(field_id, mode) {
    field = $(field_id);
    if (!field) return;
    if(mode == 'enabled'){
      field.disabled = false;
      field.readOnly = false;
      field.removeClassName('disabled-input');
      field.removeClassName('readonly-input');
      //field.addClassName('text-input');
    }
    else if(mode == 'disabled'){
      field.disabled = true;
      //field.removeClassName('text-input');
      field.removeClassName('readonly-input');
      field.addClassName('disabled-input');
    }
    else if(mode == 'readonly'){
      field.disabled = false;
      field.readOnly = true;
      //field.removeClassName('text-input');
      field.removeClassName('disabled-input');
      field.addClassName('readonly-input');
    }
}

function cambia_tipo_titular(){
  if ($('titular_colegio').checked) {
    $('colegiados_span').value='';
    $('colegiados_span').hide();
    $('a_favor_de_span').show();
  } else {
    $('a_favor_de_span').hide();
    $('colegiados_span').show();
  }
}

function cambia_mascara_doc_identidad(tipo) {
  (function($) {
    var doc_id = $('#record_doc_identidad');
    if (tipo == 'nif') {
      doc_id.setMask('nif').val('');
    } else if (tipo == 'pasaporte') {
      doc_id.setMask('pasaporte').val('');
    } else if (tipo == 'tarjeta_residencia') {
      doc_id.setMask('tarjeta_residencia').val('');
    }
  })(jQuery);
}

function muestra_periodo_exento_pago(value) {
  if (value == 'true') {
    $('periodo_exencion').style.display = 'inline-block';
  } else if (value == 'false') {
    $('periodo_exencion').style.display = 'none';
    $('record_fecha_ini_exencion_pago').value = '';
    $('record_fecha_fin_exencion_pago').value = '';
  }
}

function form_init($){
  $.mask.masks.nif = {mask: '99999999-a', defaultValue: '', autoTab: false};
  $.mask.masks.tarjeta_residencia = {mask: 'a-99999999-a', fixedchars: '[().,:/ -]', defaultValue: 'X-', autoTab: false};
  $.mask.masks.pasaporte = {mask: '*************', fixedchars: '[().,:/ -]', autoTab: false};
  $.mask.masks.c_c = {mask: '9999-9999-99-9999999999', autoTab: false};
  //$.mask.masks.phones = {mask: 'ppppppppppppppppppppppppppp', fixedchars: '[().:/ -]'};
  $.mask.masks.fecha = {mask: '99-99-9999', autoTab: false}
  $.mask.masks.fechahora = {mask: '99-99-9999 99:99', autoTab: false}
  $('input:text').setMask();
  $("form[id*='-create-'],form[id*='-update-']").FormNavigate("Va a salir del formulario, si ha hecho cambios se perderán.")
}
