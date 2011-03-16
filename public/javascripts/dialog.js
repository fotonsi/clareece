// dialog 

function createDialog(url, name) {
    return window.open(addParamToUrl(url, "mode", "dialog"), name, "height=800,width=1000,centerscreen=yes,menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,dependent=yes,dialog=yes");
}


function addParamToUrl(url, param, value) {
    return url + (url.indexOf("?") < 0 ? "?" : "&") + escape(param) + "=" + escape(value);
}

function updateHandler() {
  if(window.opener && window.opener.active_scaffold_update){
    window.opener.active_scaffold_update();
  }   
};

function checkClose(win) {
  var fn = function() {
    if(win.document)
      setTimeout(fn, 100);
    else { 
      if(window.active_scaffold_update)
        window.active_scaffold_update();
    }
  };
  setTimeout(fn, 100);
}


(function($) {
    /* Dentro de este bloque el símbolo $ resuelve a jQuery */

    window.add_empty_option_to_select = function(select, undefined_label, select_undefined) {
        var new_option = new Option(undefined_label, "");
        $(new_option).addClass("undefined");
        select.insertBefore(new_option, select.firstChild);

        if(select_undefined)
            new_option.selected = true;
    }

    $(document).ready(function() {
        if(window.opener) {
            /* Cuando tenemos una ventana que actúa como un cuadro de diálogo
             * transformamos las acciones de cancelar para que cierren la ventana,
             * en lugar de cambiar la URL
             */
            $(".form-footer a.cancel").click(function() { window.close(); });
        }

        /* Acciones para abrir ventana dialog. 
         * No usamos add() puesto que parece que live() falla con él. 
         * Las opciones del menú que abren un dialog deben tener class='dialog'. 
         */
        //$A([".active-scaffold .actions .edit", ".active-scaffold a.new", "a.dialog"]).each(function(sl) {
        $A(["a.dialog"]).each(function(sl) {
            $(sl).live("click", function(event) {
                var win = createDialog(this.href, this.id);
                event.preventDefault();
                // Se recarga el listado padre cuando se cierra la ventana
                checkClose(win);
            });
        });

        /* Llamadas remotas */
        $("a.remote").click(function(event) {
            event.preventDefault();
            $.getScript(this.href);
        });

    });

    /* Se recarga el listado padre al cerrar el dialog y al redireccionar a otras acciones dentro del dialog. 
     * Se está haciendo sin recargar al redireccionar, sólo al cerrar. Ver arriba. 
     */
    /*    
    window.onbeforeunload = function () {
      updateHandler();
    }*/
    

    var resize_handler = function() {

        /* Ajustamos el tamano del área de trabajo */
        var has_foot = $("#foot").length > 0;
        var domh = $("body").position().top + $("body").height();
        $("div#main").css("height", $("div#main").height() + ($(window).height() - domh + 1));
        //alert("domh: "+domh);
        //alert("main_height: "+$("div#main").height());
        //alert("window_height: "+$(window).height());
        $("div#lateral-menu").css("height", $("div#content").height() - 25);

        /* Ajustamos el tbody de registros */
        /*
        var tbody = $("tbody.records");
        if(tbody.size() > 0) {
            tbody.css("height", "");
            var dh = $(document).height();
            var wh = $(window).height();
            if(dh > wh && wh < (tbody.position().top + tbody.height()+20)) {
                tbody.css("height", tbody.height() - (dh - wh) - (has_foot ? ($("#foot").height() + 10) : 0));
                tbody.css("overflow-x", "hidden");
                tbody.css("overflow-y", "auto");
                tbody.find("tr").find("td:last").css("padding-right", "20px");
            }
        }*/

        /* Añadimos scroll al área de trabajo en caso de que siga siendo mayor */
        var main = $("div#main");
        if($(document).height() > $(window).height()) {
            main.css("overflow-x", "auto");
            main.css("overflow-y", "auto");
        }
    };

    $(window).resize(resize_handler);

    /* Detectamos modificaciones en el DOM para actualizar el tamaño. Esto lo
     * necesitamos para las actualizaciones por Ajax. Damos un segundo de
     * margen para que paren los eventos, ya que el propio manejador va a
     * modificar el DOM
     */
    $(window).load(function() {
        var last_dom_subtree_modified = undefined;
        var we_are_working_with_the_dom = false;
        $(document).bind("DOMSubtreeModified", function() {
            if(we_are_working_with_the_dom)
                return;

            if(last_dom_subtree_modified != undefined)
                clearTimeout(last_dom_subtree_modified);

            last_dom_subtree_modified = setTimeout(function() {
                we_are_working_with_the_dom = true;
                resize_handler();
                we_are_working_with_the_dom = false;
            }, 100);
        });

        resize_handler();
    });


})(jQuery);
