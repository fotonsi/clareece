(function($) {

    window.NiceSelect = function(input_name, new_path, url_icon, undefined_label, select_undefined_on_create) {
        var new_image = document.createElement("img");
        new_image.style.border = "0";
        new_image.src = url_icon;
        new_image.style.verticalAlign = "middle";

        var new_button = document.createElement("a");
        new_button.href = "#";
        new_button.style.marginLeft = "1ex";
        new_button.appendChild(new_image);
        $(new_button).addClass("add-new-record");

        $(new_button).bind("click", function(event) {
            event.preventDefault();

            /* Este manejador recibirá el registro recién creado */
            var handler = "handler_nice_select_" + input_name;
            window[handler] = function(options) {
                var select = $("[name='" + input_name.replace(/\[/g, '[').replace(/\]/g, ']') + "']")[0];
                select.options.length = 0;
                while(new_option = options.shift()) {
                    select.options[select.options.length] = new Option(new_option.label, new_option.value);
                    if(new_option.selected)
                        select.value = new_option.value;
                }

                add_empty_option_to_select(select, undefined_label, false);
            }

            /* Abrimos una nueva ventana y añadimos una marca para que cuando
             * el controlador nos notifique los cambios que ocurran.
             */
            var new_win = createDialog(addParamToUrl(new_path, "after_create_handler", handler),
                                       input_name);

        });

        var select = $("[name='" + input_name.replace(/\[/g, '[').replace(/\]/g, ']') + "']");
        select.after(new_button);
        add_empty_option_to_select(select[0], undefined_label, select_undefined_on_create);
    };

})(jQuery);
