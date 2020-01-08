import json
import os
import sys
import time
import psycopg2
from urllib.parse import urlparse, urlunparse, parse_qs
from storyscript.App import App


def connect_db():
    database_url = os.getenv("DATABASE_URL")
    if database_url is None:
        print("Error: Missing DATABASE_URL environment variable")
        sys.exit(1)
    u = urlparse(database_url)
    dsn = urlunparse(u._replace(query=""))
    search_path = parse_qs(u.query).get("search_path", [""])[0]
    conn = psycopg2.connect(dsn)
    conn.autocommit = True
    cursor = conn.cursor()
    cursor.execute("SELECT set_config('search_path', %s, false)", (search_path,))
    return cursor


def compile_app(app_path):
    if app_path is None:
        print("Error: Missing argument <app_path>")
        sys.exit(1)
    app_path = os.path.abspath(app_path)
    try:
        story = App.compile(app_path)
    except Exception as e:
        print(e.message())
        sys.exit(1)
    return story


def create_owner():

    def get_existing_owner():
        query = "SELECT uuid FROM owners WHERE username=%s"
        cursor.execute(query, ("hello-world-owner",))
        result = cursor.fetchone()
        return None if result is None else result[0]

    owner_uuid = get_existing_owner()
    if owner_uuid is not None:
        return owner_uuid
    query = "INSERT INTO owners (username) VALUES (%s) RETURNING uuid"
    cursor.execute(query, ("hello-world-owner",))
    owner_uuid = cursor.fetchone()[0]
    return owner_uuid


def create_token(owner_uuid):
    query = "INSERT INTO tokens (owner_uuid, type) VALUES (%s, %s) RETURNING uuid"
    cursor.execute(query, (owner_uuid, "LOGIN"))
    token_uuid = cursor.fetchone()[0]
    query = "SELECT secret FROM token_secrets WHERE token_uuid=%s"
    cursor.execute(query, (token_uuid,))
    token_secret = cursor.fetchone()[0]
    return token_secret


def create_app(owner_uuid):

    def get_existing_app():
        query = "SELECT app_uuid FROM app_dns WHERE hostname=%s"
        cursor.execute(query, ("hello-world",))
        result = cursor.fetchone()
        return None if result is None else result[0]

    app_uuid = get_existing_app()
    if app_uuid is not None:
        return app_uuid
    query = "INSERT INTO apps (owner_uuid, name) VALUES (%s, %s) RETURNING uuid"
    cursor.execute(query, (owner_uuid, "hello-world"))
    app_uuid = cursor.fetchone()[0]
    return app_uuid


def create_release(owner_uuid, app_uuid, story):
    query = "INSERT INTO releases (owner_uuid, app_uuid, payload, message) VALUES (%s, %s, %s, %s) RETURNING id"
    cursor.execute(query, (owner_uuid, app_uuid, story, 'DEPLOY'))
    release_id = cursor.fetchone()[0]
    return release_id


def is_release_deployed(app_uuid, release_id):
    query = "SELECT state FROM releases WHERE app_uuid = %s AND id = %s"
    cursor.execute(query, (app_uuid, release_id))
    release_state = cursor.fetchone()[0]
    if release_state in ["QUEUED", "DEPLOYING"]:
        return False
    elif release_state == "DEPLOYED":
        return True
    else:
        print(f"Error: Unhandled release state occurred - {release_state}")
        sys.exit(1)


cursor = connect_db()
payload = compile_app(sys.argv[1])
owner_uuid = create_owner()
# token_secret = create_token(owner_uuid)
app_uuid = create_app(owner_uuid)
release_id = create_release(owner_uuid, app_uuid, payload)

print("Waiting for deployment to complete...")
while not is_release_deployed(app_uuid, release_id):
    time.sleep(1)

print(f"Deployment complete")
