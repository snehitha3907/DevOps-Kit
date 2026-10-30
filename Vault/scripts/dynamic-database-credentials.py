#!/usr/bin/env python3
# last_verified: 2026-10-25 · hvac (Vault API client)
# vlt-017: Build a dynamic database credential flow with Vault database engine from scratch.
# This script demonstrates enabling the database secrets engine, configuring a PostgreSQL
# connection, creating a role, and generating/revoking dynamic credentials.
# Run against `vault server -dev -dev-root-token-id=myroot` with a PostgreSQL instance
# available at the configured host/port.

import os
import sys
import time

import hvac

VAULT_ADDR = os.environ.get("VAULT_ADDR", "http://127.0.0.1:8200")
VAULT_TOKEN = os.environ.get("VAULT_TOKEN", "myroot")

DB_NAME = "postgres"
DB_ROLE = "readonly-role"
DB_MOUNT = "database"


def get_client() -> hvac.Client:
    client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN)
    if not client.is_authenticated():
        raise RuntimeError("Vault authentication failed — check VAULT_ADDR and VAULT_TOKEN")
    return client


def enable_database_engine(client: hvac.Client) -> None:
    try:
        client.sys.enable_secrets_engine(
            backend_type="database",
            path=DB_MOUNT,
            description="Dynamic database credentials",
        )
        print(f"Enabled database secrets engine at {DB_MOUNT}/")
    except hvac.exceptions.InvalidPath:
        print(f"Database secrets engine already enabled at {DB_MOUNT}/")


def configure_database_connection(
    client: hvac.Client,
    host: str,
    port: int,
    username: str,
    password: str,
    database: str = "postgres",
) -> None:
    connection_config = {
        "plugin_name": "postgresql-database-plugin",
        "connection_url": f"postgresql://{{username}}:{{password}}@{host}:{port}/{database}?sslmode=disable",
        "allowed_roles": DB_ROLE,
        "username": username,
        "password": password,
    }
    try:
        client.secrets.database.configure_database(
            name=DB_NAME,
            **connection_config,
            mount_point=DB_MOUNT,
        )
        print(f"Configured database connection '{DB_NAME}'")
    except hvac.exceptions.VaultError as e:
        raise RuntimeError(f"Failed to configure database connection: {e}")


def create_role(client: hvac.Client) -> None:
    creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
        "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
    ]
    revocation_statements = [
        "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\";",
        "DROP ROLE IF EXISTS \"{{name}}\";",
    ]
    try:
        client.secrets.database.create_role(
            name=DB_ROLE,
            db_name=DB_NAME,
            creation_statements=creation_statements,
            revocation_statements=revocation_statements,
            default_ttl="1h",
            max_ttl="24h",
            mount_point=DB_MOUNT,
        )
        print(f"Created role '{DB_ROLE}'")
    except hvac.exceptions.VaultError as e:
        raise RuntimeError(f"Failed to create role: {e}")


def generate_credentials(client: hvac.Client) -> dict:
    try:
        response = client.secrets.database.generate_credentials(
            name=DB_ROLE,
            mount_point=DB_MOUNT,
        )
        creds = response["data"]
        print(f"Generated credentials: username={creds['username']}")
        return creds
    except hvac.exceptions.VaultError as e:
        raise RuntimeError(f"Failed to generate credentials: {e}")


def renew_lease(client: hvac.Client, lease_id: str, increment: int = 3600) -> dict:
    try:
        response = client.sys.renew_lease(lease_id=lease_id, increment=increment)
        print(f"Renewed lease {lease_id} by {increment}s")
        return response["data"]
    except hvac.exceptions.VaultError as e:
        raise RuntimeError(f"Failed to renew lease: {e}")


def revoke_lease(client: hvac.Client, lease_id: str) -> None:
    try:
        client.sys.revoke_lease(lease_id=lease_id)
        print(f"Revoked lease {lease_id}")
    except hvac.exceptions.VaultError as e:
        raise RuntimeError(f"Failed to revoke lease: {e}")


def main():
    pg_host = os.environ.get("PG_HOST", "localhost")
    pg_port = int(os.environ.get("PG_PORT", "5432"))
    pg_user = os.environ.get("PG_ADMIN_USER", "postgres")
    pg_pass = os.environ.get("PG_ADMIN_PASSWORD", "postgres")
    pg_db = os.environ.get("PG_DATABASE", "postgres")

    print(f"Connecting to Vault at {VAULT_ADDR}")
    client = get_client()

    print("\n1. Enabling database secrets engine...")
    enable_database_engine(client)

    print(f"\n2. Configuring PostgreSQL connection to {pg_host}:{pg_port}...")
    configure_database_connection(client, pg_host, pg_port, pg_user, pg_pass, pg_db)

    print(f"\n3. Creating role '{DB_ROLE}'...")
    create_role(client)

    print("\n4. Generating dynamic credentials...")
    creds = generate_credentials(client)
    lease_id = creds.get("lease_id")
    username = creds.get("username")
    password = creds.get("password")
    print(f"   username: {username}")
    print(f"   password: {password}")
    print(f"   lease_id: {lease_id}")
    print(f"   ttl: {creds.get('lease_duration')}s")

    if lease_id:
        print("\n5. Renewing lease...")
        renew_lease(client, lease_id)

        print("\n6. Revoking lease (cleanup)...")
        revoke_lease(client, lease_id)

    print("\nDone. Dynamic database credential flow demonstrated.")


if __name__ == "__main__":
    try:
        main()
    except RuntimeError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nInterrupted", file=sys.stderr)
        sys.exit(130)