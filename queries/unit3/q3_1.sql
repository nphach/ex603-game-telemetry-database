-- 1. Ranked matches that have at least 8 players participating
-- Requirement: SELECT, WHERE, ORDER BY, LIMIT
SELECT match_id, match_label, player_count, server_region
FROM   matches
WHERE  is_ranked = TRUE
AND    player_count >= 8
ORDER BY player_count DESC, match_id
LIMIT 10;

-- 2. The possible participation statuses?
-- Requirement: SELECT DISTINCT
SELECT DISTINCT participation_status
FROM   match_participants
ORDER BY participation_status;

-- 3. Participants that scored over 50
-- Requirement: WHERE
SELECT participation_id, match_id, player_id, score
FROM   match_participants
WHERE  score > 50
ORDER BY score DESC, participation_id;
-- Which players abadoned or contested their match?
-- Requirement: WHERE ... IN ...
SELECT participation_id, match_id, player_id, participation_status, score
FROM   match_participants
WHERE  participation_status IN ('abandoned', 'contested')
ORDER BY participation_status, participation_id;

-- 4. Match names that follow the pattern Match_1%?
-- Requirement: WHERE ... LIKE
SELECT match_id, match_label, server_region, player_count
FROM   matches
WHERE  match_label LIKE 'Match_1%'
ORDER BY match_id;
-- Update participants with no disconnection reason
-- Requirement: IS NULL, COALESCE
SELECT participation_id,
       participation_status,
       COALESCE(disconnect_reason, 'No reason provided') AS disconnect_reason
FROM   match_participants
WHERE  disconnect_reason IS NULL
ORDER BY participation_id;

-- 5. Time joined, time left, and points earned per minute
-- Requirement: SELECT, WHERE
SELECT participation_id,
       match_id,
       player_id,
       joined_at AS time_joined,
       left_at AS time_left,
       ROUND(EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0, 2) AS minutes_played,
       ROUND(score / (EXTRACT(EPOCH FROM (left_at - joined_at)) / 60.0), 2) AS points_per_minute
FROM   match_participants
ORDER BY points_per_minute DESC, participation_id;

