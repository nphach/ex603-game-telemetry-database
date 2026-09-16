# Constraints

| attribute                      | constraint                                  | notes                                                    |
| ------------------------------ | ------------------------------------------- | -------------------------------------------------------- |
| `players.username`             | unique, not null                            | every player must have a unique identity                 |
| `matches.is_active`            | not null                                    | the game should know whether a match is open or finished |
| `match_participants.match_id`  | foreign key references matches, not null    | should always to a real match                            |
| `match_participants.player_id` | foreign key references players, not null    | should always point to a real player                     |
| `match_participants.played_at` | not null                                    | event analytic that should always be tracked             |
| `match_participants.score`     | not null                                    | every math has an outcome/ score                         |
| `game_modes.name`              | not null, unique                            | players should know a mode by name                       |
| `match_modes.match_id`         | foreign key references matches, not null    | should always point to a real match                      |
| `match_modes.mode_id`          | foreign key references game_modes, not null | should always point to a real mode                       |

# ON DELETE

| foreign key                                          | ON DELETE    | notes                                                                                                                      |
| ---------------------------------------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `match_participants.player_id` → `players.player_id` | **RESTRICT** | participation history is permanant. deleting a player with history would mess with accurate analytics; should be archived. |
| `match_participants.match_id` → `matches.match_id`   | **CASCADE**  | participation has no meaning without the match; deleting a match should remove its event data.                             |
| `match_modes.match_id` → `matches.match_id`          | **CASCADE**  | mode tags are owned by the match; deleting a match should also remove its data.                                            |
| `match_modes.mode_id` → `game_modes.mode_id`         | **RESTRICT** | deleting a mode does not mean we should delete match history, which would mess with analytics; should be archived.         |
