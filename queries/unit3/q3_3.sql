-- Which players have a contested participation?

-- Subquery with IN
SELECT player_id, player_name
FROM   players
WHERE  player_id IN (
    SELECT player_id
    FROM   match_participants
    WHERE  participation_status = 'contested'
)
ORDER BY player_id;

-- CTE using WITH
WITH contested_players AS (
    SELECT player_id
    FROM   match_participants
    WHERE  participation_status = 'contested'
)
SELECT player_id, player_name
FROM   players
WHERE  player_id IN (SELECT player_id FROM contested_players)
ORDER BY player_id;

-- Another way, using EXISTS
SELECT player_id, player_name
FROM   players AS p
WHERE EXISTS (
    SELECT 1
    FROM   match_participants AS mp
    WHERE  mp.player_id = p.player_id
    AND    mp.participation_status = 'contested'
)
ORDER BY player_id;

-- The three result sets have the same number of rows
WITH in_query AS (
    SELECT player_id, player_name
    FROM   players
    WHERE  player_id IN (
        SELECT player_id
        FROM   match_participants
        WHERE  participation_status = 'contested'
    )
),
cte_query AS (
    WITH contested_players AS (
        SELECT player_id
        FROM   match_participants
        WHERE  participation_status = 'contested'
    )
    SELECT player_id, player_name
    FROM   players
    WHERE  player_id IN (SELECT player_id FROM contested_players)
),
exists_query AS (
    SELECT player_id, player_name
    FROM   players AS p
    WHERE  EXISTS (
        SELECT 1
        FROM   match_participants AS mp
        WHERE  mp.player_id = p.player_id
        AND    mp.participation_status = 'contested'
    )
)
SELECT (SELECT COUNT(*) FROM in_query) AS in_query,
       (SELECT COUNT(*) FROM cte_query) AS cte_query,
       (SELECT COUNT(*) FROM exists_query) AS exists_query;

-- Confirm that the resulting rows exist in each table
WITH in_query AS (
    SELECT player_id, player_name
    FROM   players
    WHERE  player_id IN (
        SELECT player_id
        FROM   match_participants
        WHERE  participation_status = 'contested'
    )
),
cte_query AS (
    WITH contested_players AS (
        SELECT player_id
        FROM   match_participants
        WHERE  participation_status = 'contested'
    )
    SELECT player_id, player_name
    FROM   players
    WHERE  player_id IN (SELECT player_id FROM contested_players)
),
exists_query AS (
    SELECT player_id, player_name
    FROM   players AS p
    WHERE  EXISTS (
        SELECT 1
        FROM   match_participants AS mp
        WHERE  mp.player_id = p.player_id
        AND    mp.participation_status = 'contested'
    )
)
SELECT p.player_id,
       p.player_name,
       EXISTS (SELECT 1 FROM in_query AS q WHERE q.player_id = p.player_id) AS in_query,
       EXISTS (SELECT 1 FROM cte_query AS q WHERE q.player_id = p.player_id) AS cte_query,
       EXISTS (SELECT 1 FROM exists_query AS q WHERE q.player_id = p.player_id) AS exists_query,
       EXISTS (SELECT 1 FROM in_query AS q WHERE q.player_id = p.player_id)
           AND EXISTS (SELECT 1 FROM cte_query AS q WHERE q.player_id = p.player_id)
           AND EXISTS (SELECT 1 FROM exists_query AS q WHERE q.player_id = p.player_id) AS exists_in_all
FROM   players AS p
ORDER BY p.player_id;
