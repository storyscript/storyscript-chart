{{- define "storyscript.databaseUrl" -}}
  {{- $params := dict -}}
  {{- /* scheme [ sqitch | postgresql ] */ -}}
  {{- if and (hasKey . "sqitch") .sqitch -}}
    {{- $_ := set $params "scheme" "db:pg" -}}
  {{- else -}}
    {{- $_ := set $params "scheme" "postgresql" -}}
  {{- end -}}
  {{- /* credentials [ superuser | public ] */ -}}
  {{- if and (hasKey . "superuser") .superuser -}}
    {{- $_ := set $params "credentials" (printf "%s:%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword) -}}
  {{- else -}}
    {{- $_ := set $params "credentials" (printf "%s:%s" "asyncy_authenticator" "PLEASE_CHANGE_ME") -}}
  {{- end -}}
  {{- /* host */ -}}
  {{- $_ := set $params "host" (printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace) -}}
  {{- /* database */ -}}
  {{- $_ := set $params "database" .Values.postgresql.postgresqlDatabase -}}
  {{- /* search path */ -}}
  {{- if and (hasKey . "search_path") .search_path -}}
    {{- $_ := set $params "search_path" "?search_path=app_public,app_hidden,app_private,app_runtime,public" -}}
  {{- end -}}

  {{- printf "%s://%s@%s/%s%s" (get $params "scheme") (get $params "credentials") (get $params "host") (get $params "database") (get $params "search_path") -}}
{{- end -}}


{{- define "storyscript.gatewayDNS" -}}
  {{- printf "%s.%s" .Values.gateway.dns.name .Values.gateway.dns.domain -}}
{{- end -}}
