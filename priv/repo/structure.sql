CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE IF NOT EXISTS "tg_messages" ("json" TEXT NOT NULL) STRICT;
CREATE TABLE _litestream_seq (id INTEGER PRIMARY KEY, seq INTEGER);
CREATE TABLE _litestream_lock (id INTEGER);
CREATE TABLE IF NOT EXISTS "oban_jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "state" TEXT DEFAULT 'available' NOT NULL, "queue" TEXT DEFAULT 'default' NOT NULL, "worker" TEXT NOT NULL, "args" JSON DEFAULT ('{}') NOT NULL, "meta" JSON DEFAULT ('{}') NOT NULL, "tags" JSON DEFAULT ('[]') NOT NULL, "errors" JSON DEFAULT ('[]') NOT NULL, "attempt" INTEGER DEFAULT 0 NOT NULL, "max_attempts" INTEGER DEFAULT 20 NOT NULL, "priority" INTEGER DEFAULT 0 NOT NULL, "inserted_at" TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL, "scheduled_at" TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL, "attempted_at" TEXT, "attempted_by" JSON DEFAULT ('[]') NOT NULL, "cancelled_at" TEXT, "completed_at" TEXT, "discarded_at" TEXT);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX "oban_jobs_state_queue_priority_scheduled_at_id_index" ON "oban_jobs" ("state", "queue", "priority", "scheduled_at", "id");
INSERT INTO schema_migrations VALUES(20230607064015,'2023-06-07T07:56:11');
INSERT INTO schema_migrations VALUES(20230611064225,'2023-06-11T06:42:57');
