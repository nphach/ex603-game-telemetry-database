-- A. Each producer's match_id, total event count, and total failed events (contested or abandoned)
-- For each match, how many match-participant events occurred and how many counted as failures?
-- Requirement: CASE inside aggregate
SELECT match_id,
       COUNT(*) AS total_events,
       SUM(CASE WHEN participation_status IN ('contested', 'abandoned') THEN 1 ELSE 0 END) AS total_failures
FROM   match_participants
GROUP BY match_id
ORDER BY total_failures DESC, match_id;

-- B. Regional event and failure subtotals plus one platform grand total row (server_region NULL)
-- What are failure totals and rates by match server region, and for the whole platform, without listing individual match-participant rows?
-- Requirement: GROUP BY ROLLUP
SELECT m.server_region,
       COUNT(*) AS event_count,
       SUM(CASE WHEN mp.participation_status IN ('contested', 'abandoned') THEN 1 ELSE 0 END) AS failure_count,
       ROUND(100.0 * SUM(CASE WHEN mp.participation_status IN ('contested', 'abandoned') THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS failure_rate_pct,
       CASE WHEN GROUPING(m.server_region) = 1 THEN 'platform grand total'
            ELSE 'regional subtotal'
       END AS row_type
FROM   match_participants AS mp
INNER JOIN matches AS m ON m.match_id = mp.match_id
GROUP BY ROLLUP (m.server_region)
ORDER BY GROUPING(m.server_region), m.server_region;

-- C. One row: baseline failure rate and event totals across high-volume producers (matches with at least 10 events)
-- Among matches with enough events, what combined failure rate should leadership use as the comparison baseline?
-- Requirement: WITH (CTE)
WITH producer_summary AS (
    SELECT match_id,
           COUNT(*) AS total_events,
           SUM(CASE WHEN participation_status IN ('contested', 'abandoned') THEN 1 ELSE 0 END) AS failure_count
    FROM   match_participants
    GROUP BY match_id
)
SELECT ROUND(100.0 * SUM(failure_count) / SUM(total_events), 2) AS high_volume_baseline_failure_rate_pct,
       SUM(total_events)                                       AS high_volume_total_events,
       SUM(failure_count)                                      AS high_volume_total_failures,
       COUNT(*)                                                AS high_volume_producer_count
FROM   producer_summary
WHERE  total_events >= 10;
