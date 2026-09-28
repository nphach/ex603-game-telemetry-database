DROP TABLE IF EXISTS match_modes;
DROP TABLE IF EXISTS match_participants;
DROP TABLE IF EXISTS game_modes;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

------------------------------------------------------------------------------
-- 1. players (actor) — created first (with matchtes and game_modes) because
-- there are no outgoing foreign keys
------------------------------------------------------------------------------
CREATE TABLE players (
    player_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username  VARCHAR(64) NOT NULL,
    CONSTRAINT uq_players_username UNIQUE (username)
);

------------------------------------------------------------------------------
-- 2. matches (producer) — created first (with players and game_modes) because
-- there are no outgoing foreign keys
------------------------------------------------------------------------------
CREATE TABLE matches (
    match_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    is_active BOOLEAN NOT NULL
);

------------------------------------------------------------------------------
-- 3. game_modes (catalog) - created first (with players and matches) because
-- there are no outgoing foreign keys
------------------------------------------------------------------------------
CREATE TABLE game_modes (
    mode_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name    VARCHAR(64) NOT NULL,
    CONSTRAINT uq_game_modes_name UNIQUE (name)
);

------------------------------------------------------------------------------
-- 4. match_participants (event) — created after matches and players because
-- they are referenced with foreign keys
------------------------------------------------------------------------------
CREATE TABLE match_participants (
    match_id  INTEGER   NOT NULL,
    player_id INTEGER   NOT NULL,
    played_at TIMESTAMP NOT NULL,
    score     INTEGER   NOT NULL,
    CONSTRAINT pk_match_participants PRIMARY KEY (match_id, player_id),
    CONSTRAINT fk_match
      FOREIGN KEY (match_id) REFERENCES matches (match_id)
      ON DELETE CASCADE,
    CONSTRAINT fk_player
      FOREIGN KEY (player_id) REFERENCES players (player_id)
      ON DELETE RESTRICT
);

------------------------------------------------------------------------------
-- 5. match_modes (junction) — created after matches and game_modes because
-- they are referenced with foreign keys
------------------------------------------------------------------------------
CREATE TABLE match_modes (
    match_id INTEGER NOT NULL,
    mode_id  INTEGER NOT NULL,
    CONSTRAINT pk_match_modes PRIMARY KEY (match_id, mode_id),
    CONSTRAINT fk_match_modes_match
      FOREIGN KEY (match_id) REFERENCES matches (match_id)
      ON DELETE CASCADE,
    CONSTRAINT fk_match_modes_mode
      FOREIGN KEY (mode_id) REFERENCES game_modes (mode_id)
      ON DELETE RESTRICT
);
