{{- define "flask-two-apis.name" -}}
flask-two-apis
{{- end }}

{{- define "flask-two-apis.fullname" -}}
{{ include "flask-two-apis.name" . }}-{{ .Release.Name }}
{{- end }}