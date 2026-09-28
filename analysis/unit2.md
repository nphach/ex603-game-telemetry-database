# Unit 2 — Constraint Reasoning

### The constraints table

| foreign key                                          | ON DELETE    | reason                                                                                     |
| ---------------------------------------------------- | ------------ | ------------------------------------------------------------------------------------------ |
| `match_participants.match_id` → `matches.match_id`   | **CASCADE**  | Participation only describes a specific match; without that match, the row has no meaning. |
| `match_modes.match_id` → `matches.match_id`          | **CASCADE**  | Mode tags classify a session; they should not outlive the match they label.                |
| `match_participants.player_id` → `players.player_id` | **RESTRICT** | Play history is analytic data we mean to keep; removing a player must not erase it.        |
| `match_modes.mode_id` → `game_modes.mode_id`         | **RESTRICT** | Past matches still need the catalog row so mode-based reports stay readable.               |

### ON DELETE choices

Both **CASCADE** keys on `match_id` drop `match_participants` and `match_modes` with when a match is deleted. Those rows are children of the match, and aren't standalone. They have no relevance on their own. Our analytics should not see scores or mode links for a session that no longer exists. **RESTRICT** on `match_id` would block deletion of any match that ever had a player or a tag, which would be impractical.

The **RESTRICT** constraints keep analytic history safe when an actor or catalog row is removed. Deleting a **player** must not **CASCADE** and delete their `match_participants` rows or else matches lose important data, which would corrupt analytics. The safest decision is to archive the information in the database rather so that history is preserved.
