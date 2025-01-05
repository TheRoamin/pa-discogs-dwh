CREATE TABLE IF NOT EXISTS instrument (
  instrument text,
  abbr text,
  synonyms text,
  lvl5 text,
  lvl4 text,
  lvl3 text,
  lvl2 text,
  lvl1 text
);
CREATE TABLE IF NOT EXISTS genre (
  name text,
  sub text,
  short text,
  lvl2 text,
  lvl1 text
);

CREATE TABLE IF NOT EXISTS role_to_binary (
  value integer,
  role text,
  name text
 
);
