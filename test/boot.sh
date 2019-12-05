dsn="postgres://storyscript:storyscript@localhost/storyscript"
search_path="app_public,app_hidden,app_private,app_runtime,public"
export PGOPTIONS="--search_path=$search_path"

story=$(<hello.json)

owner_uuid=$(psql $dsn -tAqc "INSERT INTO owners (username) VALUES ('user') RETURNING uuid")
token_uuid=$(psql $dsn -tAqc "INSERT INTO tokens (owner_uuid, type) VALUES ('$owner_uuid', 'LOGIN') RETURNING uuid;")
token_secret=$(psql $dsn -tAqc "SELECT secret FROM token_secrets WHERE token_uuid='$token_uuid';")
app_uuid=$(psql $dsn -tAqc "INSERT INTO apps (owner_uuid,name) VALUES ('$owner_uuid','app') RETURNING uuid;")
release_state=$(psql $dsn -tAqc "INSERT INTO releases (owner_uuid,app_uuid,payload,message) VALUES ('$owner_uuid','$app_uuid','$story','deploy') RETURNING state;")
echo $release_state
