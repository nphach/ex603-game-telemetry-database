# Unit 1 — Modeling Justification and Reflection

### Modeling justification

This database schema models a game equipped with the ability to record information player and game data, including: what players played in a match, when they played, what kind of game they were played and how they scored. The five roles in the database are as follows: `players` are the actors, `matches` are the producers players act upon, `match_participants` are the events, `game_modes` is the descriptive catalog, and `match_modes` is the many-to-many junction that tags matches with one or more modes.

##### Primary key choices

I used `INT` primary keys for `players`, `matches` and `game_modes` because it can easily be incremented, guaranteeing a unique value. Though a player's username and a game mode are unique values, they may be updated/ changed. For `matches`, `match_id` identifies each session regardless of its status. The table `match_modes` and `match_participants` use a composite primary key of `(match_id, mode_id)` and `(match_id, player_id)` respectively, which guarantees uniqueness of each row.

##### ON DELETE

The foreign keys in the schema split into two categories: analytic data and child rows. `match_participants.player_id` uses **RESTRICT** because deleting a player's participation would corrupt match history; Similarly, with `match_modes.mode_id`, **RESTRICT** is used because deleting a game mode still referenced by matches would also corrupt match history. Since this is important analytic data, I think it would be best to hold onto it. In contrast, `match_participants.match_id` and `match_modes.match_id` use **CASCADE** because participation and mode-tag rows are children of the match and are not individually important.

##### What is Enforced in the Schema

_Every_ rule in the database is defined as `NOT NULL` because violating them would corrupt the minimum telemetric data I'm aiming to keep track of. This constraint ensures incomplete rows cannot be stored — every event must record who played, in which match, when it was played, how they scored, etc. Some attributes exist that are defined initially with just a primary key (such as `game_modes.name` and `username`) because they also need to have an identity that is user-facing and still unique. A user would likely not be able to recognize players and game modes by integer values like _239810_. Unique usernames enforces a distinct player identity at database level. I did not cap the number of modes per match in the database; The many-to-many junction was intended in case a game falls under multiple game modes (ex. solo/ team, time trial/ battle royale/ etc).

### Reflection

One decision another designer may challenge is allowing multiple game modes per match `match_modes` junction, rather than placing a single `mode_id` foreign key directly on `matches`. I chose this because we a game may identify as more than one mode. For example, in a game I made, the game difficulty changes from 1-5. In the future, I want to add online play. Difficulty and multiplier play are attributes I'd want to consider in my analytics that can be characterized under `game_modes`. I kept the junction to account for these mode combinations where a game legitimately spans more than one label.

There is a trade-off with keeping this junction: the write and read cost; inserting a match requires an extra row in `match_modes`, one for every mode it corresponds to. But for a telemetry system whose interface groups by game mode, that join is predictable and index-friendly. I accepted this complexity because I think this is important data to model.
