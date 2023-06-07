CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "tg_messages" ("json" TEXT NOT NULL) STRICT;
INSERT INTO schema_migrations VALUES(20230607064015,'2023-06-07T07:14:29');
