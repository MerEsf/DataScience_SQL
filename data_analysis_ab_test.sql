-------------------- reformat the data

SELECT 
  item_id,
  test_a AS test_assignment,
  (CASE WHEN test_a is NOT NULL then 'test_a' ELSE NULL END) AS test_number,
  (CASE WHEN test_a is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_b AS test_assignment,
  (CASE WHEN test_b is NOT NULL then 'test_b' ELSE NULL END) AS test_number,
  (CASE WHEN test_b is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_c AS test_assignment,
  (CASE WHEN test_c is NOT NULL then 'test_c' ELSE NULL END) AS test_number,
  (CASE WHEN test_c is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_d AS test_assignment,
  (CASE WHEN test_d is NOT NULL then 'test_d' ELSE NULL END) AS test_number,
  (CASE WHEN test_d is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_e AS test_assignment,
  (CASE WHEN test_e is NOT NULL then 'test_e' ELSE NULL END) AS test_number,
  (CASE WHEN test_e is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT 
  item_id,
  test_f AS test_assignment,
  (CASE WHEN test_f is NOT NULL then 'test_f' ELSE NULL END) AS test_number,
  (CASE WHEN test_f is NOT NULL then '2013-01-05 00:00:00' ELSE NULL END) AS date
FROM 
  dsv1069.final_assignments_qa
ORDER BY test_number
LIMIT 100;

-------------------- compute order_binary for the 30 day window after the test_start_date

SELECT
  test_assignment,
  COUNT(DISTINCT item_id) AS number_of_items,
  SUM(order_binary) AS items_ordered_30d
FROM
  (
  SELECT
  item_test_2_order.item_id,
  item_test_2_order.test_assignment,
  item_test_2_order.test_number,
  item_test_2_order.test_start_date,
  item_test_2_order.created_at,
  MAX(CASE WHEN (created_at > test_start_date AND
            DATE_PART('day', created_at-test_start_date) <= 30)
      THEN 1 ELSE 0 END) AS order_binary
FROM
  (
  SELECT
    final_assignments.*,
    DATE(orders.created_at) AS created_at
  FROM 
    dsv1069.final_assignments AS final_assignments
  LEFT JOIN
    dsv1069.orders AS orders
  ON
    final_assignments.item_id = orders.item_id
  WHERE
    test_number = 'item_test_2'
  ) AS item_test_2_order
GROUP BY
  item_test_2_order.item_id,
  item_test_2_order.test_assignment,
  item_test_2_order.test_number,
  item_test_2_order.test_start_date,
  item_test_2_order.created_at
  ) AS order_binary
GROUP BY
  test_assignment;
  
  -------------------- ompute view_binary for the 30 day window after the test_start_date
  
SELECT
  item_test_2_view.item_id,
  item_test_2_view.test_assignment,
  item_test_2_view.test_number,
  MAX(CASE WHEN (view_date > test_start_date AND
            DATE_PART('day', view_date-test_start_date) <= 30)
      THEN 1 ELSE 0 END) AS view_binary
FROM
  (
  SELECT
    final_assignments.*,
    DATE(events.event_time) AS view_date
  FROM 
    dsv1069.final_assignments AS final_assignments
  LEFT JOIN
    (
    SELECT
      event_time,
      CASE WHEN parameter_name = 'item_id' THEN CAST(parameter_value AS numeric) ELSE NULL END AS item_id
    FROM
      dsv1069.events
    WHERE
      event_name = 'view_item'
    ) AS events
  ON
    final_assignments.item_id = events.item_id
  WHERE
    test_number = 'item_test_2'
  ) AS item_test_2_view
GROUP BY
  item_test_2_view.item_id,
  item_test_2_view.test_assignment,
  item_test_2_view.test_number
LIMIT 100;

-------------------- compute the lifts in metrics and the p-values for the binary metrics ( 30 day order binary and 30 day view binary) using a interval 95% confidence

SELECT 
  test_assignment,
  test_number,
  count(item) AS item,
  SUM(view_binary_30d) AS view_binary_30d
FROM 
  (SELECT 
    final_assignments.item_id AS item,
    test_assignment,
    test_number,
    test_start_date,
    MAX((CASE WHEN date(event_time) - date(test_start_date) BETWEEN 0 AND 30 THEN 1 ELSE 0 END)) AS view_binary_30d
  FROM 
    dsv1069.final_assignments
  LEFT JOIN dsv1069.view_item_events
  ON final_assignments.item_id = view_item_events.item_id
  WHERE test_number = 'item_test_2'
  GROUP BY
    final_assignments.item_id,
    test_assignment,
    test_number,
    test_start_date
  ) AS view_binary
GROUP BY
  test_assignment,
  test_number,
  test_start_date

