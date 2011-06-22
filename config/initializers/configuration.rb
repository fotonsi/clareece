# Development
WORK_IN_LOCAL = false
RECIBOS_REMESA_A_GENERAR = 500
MOVIMIENTOS_TRANSACCION_A_GENERAR = 500
LOCAL_DELIVERY = nil

# Directorios
DIR_PLANTILLAS_PDF="public/ficheros/plantillas_pdf"
DIR_DIPLOMAS="ficheros/diplomas"
DIR_ARCHIVO_DOCS="/mnt/"

GAPPS_CAPTCHA_URL="https://www.google.com/accounts"

# LDAP
LDAP_LOGIN=false
URL_LDAP=""
LDAP_SUFFIX=''
LDAP_SEARCH_USER=''
LDAP_SEARCH_PASS=""
LDAP_LOCAL_GROUPS=%w()

# SMS
URL_SERVICIO_SMS=""
USUARIO_SMS=""
PASSWORD_SMS=""
REMITENTE_SMS=""

# Cursos #FIXME Debe ir en al BD
NOTA_APROBADO = 5
PORC_MIN_ASISTENCIA = 90

# Correos
EMAIL_SERVIDOR = ""

# Default formats
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = "%d-%m-%Y %H:%M"
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = "%d-%m-%Y"
TagList.delimiter = " "

# Nombres de ficheros según etiquetas
NOMBRES_FICHEROS = {'certificado academico.pdf' => :certificado_academico,
                    'documentos_a_dni.pdf' => :documento_identidad,
                    'documentos_r_dni.pdf' => :documento_identidad_r,
                    'documentos_foto.png' => :foto_documento_identidad,
                    'títulos.pdf' => :titulo_profesional,
                    'cursos.pdf' => :cursos,
                    'varios.pdf' => :varios,
}

# Cargar configuración local
require('config/local') if File.exist?('config/local.rb')
