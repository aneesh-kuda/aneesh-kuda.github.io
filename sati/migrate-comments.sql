-- Run once in Supabase SQL Editor: comments can now target reflections and documents
alter table comments add column if not exists target_type text not null default 'activity';
alter table comments alter column activity_id drop not null;
