CREATE SCHEMA IF NOT EXISTS api;

CREATE TABLE IF NOT EXISTS api.tb_users (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  UNIQUE NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    status      SMALLINT     DEFAULT 1 CHECK (status IN (0, 1)),
    created_at  TIMESTAMPTZ  DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION api.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tb_users_updated_at
    BEFORE UPDATE ON api.tb_users
    FOR EACH ROW EXECUTE FUNCTION api.update_updated_at();

GRANT USAGE ON SCHEMA api TO web_anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.tb_users TO web_anon;
GRANT USAGE, SELECT ON SEQUENCE api.tb_users_id_seq TO web_anon;
