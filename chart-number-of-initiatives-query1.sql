SELECT
    `PR`.`project_key`,
    COUNT(`Issue`.`issue_id`) AS `Issues`
FROM
    `jira_issue` AS `Issue`
INNER JOIN
    `jira_project` AS `PR` ON `PR`.`project_id` = `Issue`.`project_id`
WHERE
    `Issue`.`issue_type` = 'Initiative'
    -- Condition to filter the query using the calendar control
    AND `Issue`.`created_at` BETWEEN {CAL_CREATED_AT.START} AND {CAL_CREATED_AT.END}
    -- Condition to filter the query using the dropdown status control
    AND {DROPDOWN_STATUS.IN('`Issue`.`status`')}
    -- Condition to filter the query using the dropdown project control
    AND {DROPDOWN_PROJECT.IN('`PR`.`project_key`')}
GROUP BY
    `PR`.`project_key`
LIMIT
    3000;
