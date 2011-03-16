# Calendar Date Select config

CalendarDateSelect::FORMATS[:spanish] = {
  :date => "%d-%m-%Y",
  :time => " %H:%M",
  :javascript_include => "format_spanish"
}

CalendarDateSelect.format = :spanish
CalendarDateSelect.default_options.update(:before_show => 'this.value = this.value.replace(/-/g, "/"); this.calendar_date_select.parseDate();', :after_close => 'this.value = this.value.replace(/\//g, "-");', :onchange => 'this.value = this.value.replace(/\//g, "-");', :size => 15)
