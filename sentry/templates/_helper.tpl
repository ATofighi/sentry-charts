{{/* vim: set filetype=mustache: */}}

{{- define "sentry.prefix" -}}
    {{- if .Values.prefix -}}
        {{.Values.prefix}}-
    {{- else -}}
    {{- end -}}
{{- end -}}

{{- define "nginx.port" -}}{{ default "8080" .Values.nginx.containerPort }}{{- end -}}
{{- define "relay.port" -}}3000{{- end -}}
{{- define "sentry.port" -}}9000{{- end -}}
{{- define "snuba.port" -}}1218{{- end -}}
{{- define "symbolicator.port" -}}3021{{- end -}}

{{- define "relay.image" -}}
{{- default "getsentry/relay" .Values.images.relay.repository -}}
:
{{- default .Chart.AppVersion .Values.images.relay.tag -}}
{{- end -}}
{{- define "sentry.image" -}}
{{- default "getsentry/sentry" .Values.images.sentry.repository -}}
:
{{- default .Chart.AppVersion .Values.images.sentry.tag -}}
{{- end -}}
{{- define "snuba.image" -}}
{{- default "getsentry/snuba" .Values.images.snuba.repository -}}
:
{{- default .Chart.AppVersion .Values.images.snuba.tag -}}
{{- end -}}

{{- define "symbolicator.image" -}}
{{- default "getsentry/symbolicator" .Values.images.symbolicator.repository -}}
:
{{- .Values.images.symbolicator.tag -}}
{{- end -}}

{{- define "dbCheck.image" -}}
{{- default "subfuzion/netcat" .Values.hooks.dbCheck.image.repository -}}
:
{{- default "latest" .Values.hooks.dbCheck.image.tag -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "sentry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sentry.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sentry.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "sentry-postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "sentry.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.redis.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "sentry-redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "sentry.rabbitmq.fullname" -}}
{{- printf "%s-%s" .Release.Name "rabbitmq" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sentry.clickhouse.fullname" -}}
{{- printf "%s-%s" .Release.Name "clickhouse" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sentry.kafka.fullname" -}}
{{- printf "%s-%s" .Release.Name "kafka" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sentry.zookeeper.fullname" -}}
{{- if .Values.kafka.zookeeper.fullnameOverride -}}
{{- .Values.kafka.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.kafka.zookeeper.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

/*
Set Snuba api address
*/
{{- define "snuba.api" -}}
{{- if .Values.snuba.api.address -}}
{{ .Values.snuba.api.address }}
{{- else -}}
http://{{ template "sentry.fullname" . }}-snuba:{{ template "snuba.port" . }}
{{- end -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "sentry.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sentry.postgresql.fullname" . -}}
{{- else -}}
{{ required "A valid .Values.externalPostgresql.host is required" .Values.externalPostgresql.host }}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "sentry.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sentry.postgresql.fullname" . -}}
{{- else -}}
{{- template "sentry.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "sentry.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
{{- default 5432 .Values.postgresql.service.port }}
{{- else -}}
{{- required "A valid .Values.externalPostgresql.port is required" .Values.externalPostgresql.port -}}
{{- end -}}
{{- end -}}

{{/*
Set postgresql username
*/}}
{{- define "sentry.postgresql.username" -}}
{{- if .Values.postgresql.enabled -}}
{{- default "postgres" .Values.postgresql.postgresqlUsername }}
{{- else -}}
{{ required "A valid .Values.externalPostgresql.username is required" .Values.externalPostgresql.username }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql password
*/}}
{{- define "sentry.postgresql.password" -}}
{{- if .Values.postgresql.enabled -}}
{{- default "" .Values.postgresql.postgresqlPassword }}
{{- else -}}
{{ required "A valid .Values.externalPostgresql.password is required" .Values.externalPostgresql.password }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql database
*/}}
{{- define "sentry.postgresql.database" -}}
{{- if .Values.postgresql.enabled -}}
{{- default "sentry" .Values.postgresql.postgresqlDatabase }}
{{- else -}}
{{ required "A valid .Values.externalPostgresql.database is required" .Values.externalPostgresql.database }}
{{- end -}}
{{- end -}}

{{/*
Set redis host
*/}}
{{- define "sentry.redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- template "sentry.redis.fullname" . -}}-master
{{- else -}}
{{ required "A valid .Values.externalRedis.host is required" .Values.externalRedis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis secret
*/}}
{{- define "sentry.redis.secret" -}}
{{- if .Values.redis.enabled -}}
{{- template "sentry.redis.fullname" . -}}
{{- else -}}
{{- template "sentry.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "sentry.redis.port" -}}
{{- if .Values.redis.enabled -}}
{{- default 6379 .Values.redis.redisPort }}
{{- else -}}
{{ required "A valid .Values.externalRedis.port is required" .Values.externalRedis.port }}
{{- end -}}
{{- end -}}

{{/*
Set redis password
*/}}
{{- define "sentry.redis.password" -}}
{{- if .Values.redis.enabled -}}
{{ .Values.redis.password }}
{{- else if .Values.externalRedis.password -}}
{{ .Values.externalRedis.password }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sentry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "sentry.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse host
*/}}
{{- define "sentry.clickhouse.host" -}}
{{- if .Values.clickhouse.enabled -}}
{{- template "sentry.clickhouse.fullname" . -}}
{{- else -}}
{{ required "A valid .Values.externalClickhouse.host is required" .Values.externalClickhouse.host }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse port
*/}}
{{- define "sentry.clickhouse.port" -}}
{{- if .Values.clickhouse.enabled -}}
{{- default 9000 .Values.clickhouse.clickhouse.tcp_port }}
{{- else -}}
{{ required "A valid .Values.externalClickhouse.tcpPort is required" .Values.externalClickhouse.tcpPort }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse HTTP port
*/}}
{{- define "sentry.clickhouse.http_port" -}}
{{- if .Values.clickhouse.enabled -}}
{{- default 8123 .Values.clickhouse.clickhouse.http_port }}
{{- else -}}
{{ required "A valid .Values.externalClickhouse.httpPort is required" .Values.externalClickhouse.httpPort }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse Database
*/}}
{{- define "sentry.clickhouse.database" -}}
{{- if .Values.clickhouse.enabled -}}
default
{{- else -}}
{{ required "A valid .Values.externalClickhouse.database is required" .Values.externalClickhouse.database }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse Authorization
*/}}
{{- define "sentry.clickhouse.auth" -}}
--user {{ include "sentry.clickhouse.username" . }} --password {{ include "sentry.clickhouse.password" .| quote }}
{{- end -}}

{{/*
Set ClickHouse User
*/}}
{{- define "sentry.clickhouse.username" -}}
{{- if .Values.clickhouse.enabled -}}
  {{- if .Values.clickhouse.clickhouse.configmap.users.enabled -}}
{{ (index .Values.clickhouse.clickhouse.configmap.users.user 0).name }}
  {{- else -}}
default
  {{- end -}}
{{- else -}}
{{ required "A valid .Values.externalClickhouse.username is required" .Values.externalClickhouse.username }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse Password
*/}}
{{- define "sentry.clickhouse.password" -}}
{{- if .Values.clickhouse.enabled -}}
  {{- if .Values.clickhouse.clickhouse.configmap.users.enabled -}}
{{ (index .Values.clickhouse.clickhouse.configmap.users.user 0).config.password }}
  {{- else -}}
  {{- end -}}
{{- else -}}
{{ .Values.externalClickhouse.password }}
{{- end -}}
{{- end -}}

{{/*
Set ClickHouse cluster name
*/}}
{{- define "sentry.clickhouse.cluster.name" -}}
{{- if .Values.clickhouse.enabled -}}
{{ .Release.Name | printf "%s-clickhouse" }}
{{- else -}}
{{ default "" .Values.externalClickhouse.clusterName }}
{{- end -}}
{{- end -}}

{{/*
Set Kafka Confluent hosts
*/}}
{{- define "sentry.kafka.hosts" -}}
{{- if .Values.kafka.enabled -}}
{{- include "sentry.kafka.fullname" . -}}
{{- else -}}
{{- required "A valid .Values.externalKafka.hosts is required" .Values.externalKafka.hosts -}}
{{- end -}}
{{- end -}}

{{/*
Set Kafka Confluent port
*/}}
{{- define "sentry.kafka.port" -}}
{{- if and (.Values.kafka.enabled) (.Values.kafka.service.port) -}}
{{- .Values.kafka.service.port -}}
{{- else -}}
{{- required "A valid .Values.externalKafka.port is required" .Values.externalKafka.port -}}
{{- end -}}
{{- end -}}

{{/*
Set Kafka bootstrappers
*/}}
{{- define "sentry.kafka.bootstrappers" -}}
{{- if .Values.kafka.enabled -}}
{{- printf "%s:%s" (include "sentry.kafka.fullname" .) ($.Values.kafka.service.port | toString) -}}
{{- else -}}
{{- range $index, $element := .Values.externalKafka.hosts -}}{{if $index}},{{end}}{{- printf "%s:%s" $element ($.Values.externalKafka.port | toString) -}}{{end}}
{{- end -}}
{{- end -}}


{{/*
Set RabbitMQ host
*/}}
{{- define "sentry.rabbitmq.host" -}}
{{- if .Values.rabbitmq.enabled -}}
{{- default "sentry-rabbitmq-ha"  (include "sentry.rabbitmq.fullname" .) -}}
{{- else -}}
{{ .Values.rabbitmq.host }}
{{- end -}}
{{- end -}}


{{/*
Common Snuba environment variables
*/}}
{{- define "sentry.snuba.env" -}}
- name: SNUBA_SETTINGS
  value: docker
- name: SENTRY_EVENT_RETENTION_DAYS
  value: {{ .Values.sentry.eventRetentionDays | quote }}
- name: CLICKHOUSE_SINGLE_NODE
  value: {{ if .Values.externalClickhouse.clusterName }}"false"{{ else }}"true"{{end}}
{{- if .Values.metrics.enabled }}
- name: DOGSTATSD_HOST
  value: "{{ template "sentry.fullname" . }}-metrics"
- name: DOGSTATSD_PORT
  value: "9125"
{{- end}}
- name: DEFAULT_BROKERS
  value: {{ include "sentry.kafka.bootstrappers" . | quote }}
- name: SENTRY_DSN
  value: {{ .Values.snuba.sentryDsn | quote }}
- name: CLICKHOUSE_HOST
  value: {{ include "sentry.clickhouse.host" . | quote }}
- name: REDIS_HOST
  value: {{ include "sentry.redis.host" . | quote }}
- name: REDIS_PORT
  value: {{ include "sentry.redis.port" . | quote }}
- name: CLICKHOUSE_HTTP_PORT
  value: {{ include "sentry.clickhouse.http_port" . | quote }}
{{- end -}}
