{{- define "storyscript.databaseUrl" -}}
  {{- $credentials := printf "%s:%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword -}}
  {{- $host := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- printf "postgres://%s@%s/%s" $credentials $host .Values.postgresql.postgresqlDatabase -}}
{{- end -}}
