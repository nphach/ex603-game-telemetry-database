## Task 4.1

A **live operations manager** on the game team would act on the per-producer breakdown and decide which `match_id` values get a deeper audit. The averages hide the spread of scores, and event counts hide who was counted and whether sessions were finished or not (contested/abandoned), so next I would look into status, region, and time on the worst-looking matches instead. For query 3 I used at least **10** events per producer because under 10 looks to be an outlier; that drops only match **4** and keeps the rest comparable, while a lower threshold would let the insignificant match skew the overall data and dilute relevance.

## Task 4.2

### Part A

One query answers two things side by side: how many **match_participants** rows each producer has, and how many of those are failures (contested/ abandoned). Matches **3**, **5**, **9**, and **11** tie with five failures each. Match **10** has nineteen events and zero failures, an outlier the other way.

### Part B

A **server operator** (who owns match servers by `server_region`) needs subtotals, not every event row. In the ROLLUP output, each region row is a **regional subtotal**; the row with blank `server_region` and `row_type`, **platform grand total**, is everything combined (**200** events, **44** failures, **22%**). EU is highest in this data (**35%**); NA is **0%** here. The grand total is what you use for one platform-wide payout or SLA call; the region rows show where to send follow-up without rebuilding the math in a sheet.

### Part C

The pipeline first summarizes each producer, then keeps only matches with at least ten events (same floor as 4.1 query 3). The combined failure rate on that high-volume set is **21.65%** (**42** failures out of **194** events across twelve producers). That is the baseline I would compare high-volume producers against.

### Write up

Part A gets event totals and failure totals in one pass over `match_participants`. Two separate queries--one counting all events per match, one counting only contested/abandoned--would scan the same table twice. At a million rows that is a lot of extra I/O for the same answer, and the two runs could disagree if new events land in between. One pass with `SUM(CASE WHEN …)` keeps one definition of failure in one place, which is what I would run on a schedule.
