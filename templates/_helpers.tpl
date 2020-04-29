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
    {{- $_ := set $params "credentials" (printf "%s:%s" .Values.graphql.postgresqlUsername .Values.graphql.postgresqlPassword) -}}
  {{- end -}}
  {{- /* host */ -}}
  {{- if .Values.postgresql.create -}}
    {{- $_ := set $params "host" (printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace) -}}
  {{- else -}}
    {{- $_ := set $params "host" (required "A .Values.postgresql.postgresqlHost is required if postgresql.create=false" .Values.postgresql.postgresqlHost) -}}
  {{- end -}}
  {{- /* database */ -}}
  {{- $_ := set $params "database" .Values.postgresql.postgresqlDatabase -}}
  {{- /* search path */ -}}
  {{- if and (hasKey . "search_path") .search_path -}}
    {{- $_ := set $params "search_path" "?search_path=app_public,app_hidden,app_private,app_runtime,public" -}}
  {{- end -}}

  {{- printf "%s://%s@%s/%s%s" (get $params "scheme") (get $params "credentials") (get $params "host") (get $params "database") (get $params "search_path") -}}
{{- end -}}

{{- define "storyscript.image" -}}
  {{- $repository := required "An image repository must be specified" .repository -}}
  {{- printf "%s:%s" $repository (default "latest" .tag) -}}
{{- end -}}
