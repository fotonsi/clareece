// Añadimos reload_list a los métodos de ActiveScaffold

ActiveScaffold.reload_list = function(list, url, spinner) {
  new Ajax.Updater($(list), url, {
    method: 'get',
    asynchronous: true,
    evalScripts: true,
    onCreate: function(){if($(spinner)) $(spinner).toggle()}
  });
}
