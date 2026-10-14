-- Part A
-- The duration of a round is left_at - joined_at. This query looks for matches where
-- the duration is less than 10 minutes, but drops all rows where left_at is null
-- instead of marking the duration as 0 minutes.
SELECT participation_id,
       match_id,
       player_id,
       joined_at,
       left_at,
       ROUND(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 2) AS duration
FROM   match_participants
WHERE  EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0 < 10
ORDER BY duration, participation_id;

-- The short-session count, the rows it dropped, and the table total.
-- 19 + 34 = 53, which is not 200.
SELECT (SELECT COUNT(*)
        FROM   match_participants
        WHERE  EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0 < 10) AS under_10_minutes,
       (SELECT COUNT(*)
        FROM   match_participants
        WHERE  left_at IS NULL) AS missing_leave_time,
       (SELECT COUNT(*) FROM match_participants) AS total_participations;

-- Sessions shorter than 10 minutes, including ones with no duration (no left_at time).
SELECT participation_id,
       match_id,
       player_id,
       joined_at,
       left_at,
       ROUND(COALESCE(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 0), 2) AS duration
FROM   match_participants
WHERE  left_at IS NULL
OR     EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0 < 10
ORDER BY duration, participation_id;

-- Full count once missing leave times are included.
SELECT COUNT(*) AS sessions_under_10_minutes
FROM   match_participants
WHERE  left_at IS NULL
OR     EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0 < 10;


-- Part B
-- duration is named in SELECT and used in WHERE. WHERE runs before SELECT, so the alias does not exist yet and produces the following error:
-- [42703] ERROR: column "duration" does not exist
--   Position: 219
SELECT participation_id,
       match_id,
       player_id,
       joined_at,
       left_at,
       ROUND(COALESCE(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 0), 2) AS duration
FROM   match_participants
WHERE  duration < 10
ORDER BY duration, participation_id;


-- Repeat the duration expression in WHERE.
SELECT participation_id,
       match_id,
       player_id,
       joined_at,
       left_at,
       ROUND(COALESCE(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 0), 2) AS duration
FROM   match_participants
WHERE  ROUND(COALESCE(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 0), 2) < 10
ORDER BY duration, participation_id;

-- Compute duration in a CTE first, then filter.
WITH rounds AS (
    SELECT participation_id,
           match_id,
           player_id,
           joined_at,
           left_at,
           ROUND(COALESCE(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 0), 2) AS duration
    FROM   match_participants
)
SELECT participation_id, match_id, player_id, joined_at, left_at, duration
FROM   rounds
WHERE  duration < 10
ORDER BY duration, participation_id;

