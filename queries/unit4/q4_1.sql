-- 1. Platform-wide event count, score metric summary (total, average, min, max), and distinct actor count on match_participants.
-- What are the basic score metrics across all match-participant events, and how many distinct players appear?
SELECT COUNT(*)                  AS event_count,
       SUM(score)                AS total_score,
       AVG(score)                AS average_score,
       MIN(score)                AS minimum_score,
       MAX(score)                AS maximum_score,
       COUNT(DISTINCT player_id) AS distinct_players
FROM   match_participants;

-- 2. Each producer's event count and average score, sorted from the most events to the fewest.
-- For each match, how many match-participant events were recorded and what was the average score?
SELECT match_id,
       COUNT(*)   AS event_count,
       AVG(score) AS average_score
FROM   match_participants
GROUP BY match_id
ORDER BY event_count DESC, match_id;

-- 3. Each qualifying producer's match_id and event count for producers with more than 10 events.
-- Which matches have enough match-participant events for their failure rate to mean anything?
-- Requirement: HAVING
SELECT match_id,
       COUNT(*) AS event_count
FROM   match_participants
GROUP BY match_id
HAVING COUNT(*) >= 10
ORDER BY match_id;

-- 4. Each server region and participation status pair's event count and average score.
-- How do event volume and average score differ by match server region and participation status together?
SELECT m.server_region,
       mp.participation_status,
       COUNT(*)                AS event_count,
       ROUND(AVG(mp.score), 2) AS average_score
FROM   match_participants AS mp
INNER JOIN matches AS m ON m.match_id = mp.match_id
GROUP BY m.server_region, mp.participation_status
ORDER BY m.server_region, mp.participation_status;
