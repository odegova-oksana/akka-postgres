-- This CQL script will create the keyspace and all tables needed for the this sample. 
-- It includes the messages and snapshot tables (write-side) and the projection tables (read-side).

-- NOTE: the keyspace as created here is probably not what you need in a production environment. 
-- This is good enough for local development though.

DROP TABLE IF EXISTS public.journal;

CREATE TABLE IF NOT EXISTS public.journal (
  ordering BIGSERIAL,
  persistence_id VARCHAR(255) NOT NULL,
  sequence_number BIGINT NOT NULL,
  deleted BOOLEAN DEFAULT FALSE,
  tags VARCHAR(255) DEFAULT NULL,
  message BYTEA NOT NULL,
  PRIMARY KEY(persistence_id, sequence_number)
);

CREATE UNIQUE INDEX journal_ordering_idx ON public.journal(ordering);

DROP TABLE IF EXISTS public.snapshot;

CREATE TABLE IF NOT EXISTS public.snapshot (
  persistence_id VARCHAR(255) NOT NULL,
  sequence_number BIGINT NOT NULL,
  created BIGINT NOT NULL,
  snapshot BYTEA NOT NULL,
  PRIMARY KEY(persistence_id, sequence_number)
);

create schema shoppingcartservice;

CREATE TABLE IF NOT EXISTS shoppingcartservice.messages (
  persistence_id VARCHAR(255),
  partition_nr BIGINT,
  sequence_nr BIGINT,
  timestamp timestamp,
  timebucket VARCHAR(255),
  writer_uuid VARCHAR(255),
  ser_id int,
  ser_manifest VARCHAR(255),
  event_manifest VARCHAR(255),
  event BYTEA,
  meta_ser_id int,
  meta_ser_manifest VARCHAR(255),
  meta BYTEA,
  PRIMARY KEY (persistence_id, partition_nr, sequence_nr, timestamp));

CREATE TABLE IF NOT EXISTS shoppingcartservice.tag_views (
  tag_name VARCHAR(255),
  persistence_id VARCHAR(255),
  sequence_nr bigint,
  timebucket bigint,
  timestamp timestamp,
  tag_pid_sequence_nr bigint,
  writer_uuid VARCHAR(255),
  ser_id int,
  ser_manifest VARCHAR(255),
  event_manifest VARCHAR(255),
  event BYTEA,
  meta_ser_id int,
  meta_ser_manifest VARCHAR(255),
  meta BYTEA,
  PRIMARY KEY (tag_name, timebucket, timestamp, persistence_id, tag_pid_sequence_nr));

CREATE TABLE IF NOT EXISTS shoppingcartservice.tag_write_progress(
  persistence_id VARCHAR(255),
  tag VARCHAR(255),
  sequence_nr bigint,
  tag_pid_sequence_nr VARCHAR(255),
  timestamp timestamp,
  PRIMARY KEY (persistence_id, tag));

CREATE TABLE IF NOT EXISTS shoppingcartservice.tag_scanning(
  persistence_id VARCHAR(255),
  sequence_nr bigint,
  PRIMARY KEY (persistence_id));

CREATE TABLE IF NOT EXISTS shoppingcartservice.metadata(
  persistence_id VARCHAR(255) PRIMARY KEY,
  deleted_to bigint);

CREATE TABLE IF NOT EXISTS shoppingcartservice.all_persistence_ids(
  persistence_id VARCHAR(255) PRIMARY KEY);

CREATE TABLE IF NOT EXISTS shoppingcartservice.snapshots (
  persistence_id VARCHAR(255),
  sequence_nr bigint,
  timestamp bigint,
  ser_id int,
  ser_manifest VARCHAR(255),
  snapshot_data BYTEA,
  snapshot BYTEA,
  meta_ser_id int,
  meta_ser_manifest VARCHAR(255),
  meta BYTEA,
  PRIMARY KEY (persistence_id, sequence_nr));

CREATE TABLE IF NOT EXISTS shoppingcartservice.offset_store (
  projection_name VARCHAR(255),
  partition int,
  projection_key VARCHAR(255),
  offset_name VARCHAR(255),
  manifest VARCHAR(255),
  last_updated timestamp,
  PRIMARY KEY (projection_name, partition, projection_key));
