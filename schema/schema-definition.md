# Schema Definition

### 1. `players` (actor)

| attribute   | domain    | notes                                        |
| ----------- | --------- | -------------------------------------------- |
| `player_id` | `INT`     | player identifier                            |
| `username`  | `VARCHAR` | the player's display name (unique, not null) |

**primary key(s):** `player_id`

---

### 2. `matches` (producer)

| attribute   | domain    | notes                                               |
| ----------- | --------- | --------------------------------------------------- |
| `match_id`  | `INT`     | match identifier                                    |
| `is_active` | `BOOLEAN` | whether the match is open or in progress (not null) |

**primary key(s):** `match_id`

---

### 3. `match_participants` (event)

| attribute   | domain      | notes                                                                     |
| ----------- | ----------- | ------------------------------------------------------------------------- |
| `match_id`  | `INT`       | what match this corresponds to (foreign key references matches, not null) |
| `player_id` | `INT`       | what player played this match (foreign key references players, not null)  |
| `played_at` | `TIMESTAMP` | when the player joined or completed the match (not null)                  |
| `score`     | `INT`       | numeric metric aggregated in analytics (not null)                         |

**primary key(s):** `match_id`, `player_id`

---

### 4. `game_modes` (catalog)

| attribute | domain    | notes                                        |
| --------- | --------- | -------------------------------------------- |
| `mode_id` | `INT`     | game mode identifier                         |
| `name`    | `VARCHAR` | the name of the game mode (not null, unique) |

**primary key(s):** `mode_id`

---

### 5. `match_modes` (junction)

| attribute  | domain | notes                                                              |
| ---------- | ------ | ------------------------------------------------------------------ |
| `match_id` | `INT`  | match identifier (foreign key references matches, not null)        |
| `mode_id`  | `INT`  | game mode identifier (foreign key references game_modes, not null) |

**primary key(s):** `match_id`, `mode_id`
