{{- define "storyscript.sqitchUrl" -}}
  {{- $credentials := printf "%s:%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword -}}
  {{- $host := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- printf "db:pg://%s@%s:5432/%s" $credentials $host .Values.postgresql.postgresqlDatabase -}}
{{- end -}}

{{- define "storyscript.superuserUrl" -}}
  {{- $credentials := printf "%s:%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword -}}
  {{- $host := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- printf "postgresql://%s@%s/%s" $credentials $host .Values.postgresql.postgresqlDatabase -}}
{{- end -}}

{{- define "storyscript.publicUrl" -}}
  {{- $host := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- printf "postgresql://asyncy_authenticator:PLEASE_CHANGE_ME@%s/storyscript" $host -}}
{{- end -}}
