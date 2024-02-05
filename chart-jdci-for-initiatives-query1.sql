SELECT 
  `PR`.`Project_Key`,
  AVG
	
	-- Calculation of Jira Data Completeness Index
    (
        CASE WHEN `CKR`.`value` IS NULL THEN 0 ELSE 0.125 END +
        CASE WHEN `CO`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `DOKR`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `CI`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `L1M`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `CIMP`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `R&D`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `RAG`.`value` IS NULL THEN 0 ELSE 0.125 END
    )  AS `JDCI`
	
	
	
FROM 
    `jira_issue` AS `Issue`
    INNER JOIN 
        `jira_project` AS `PR` ON `PR`.`project_id` = `Issue`.`project_id`
    -- Left join to bring Company Objective
    LEFT JOIN 
        `jira_issue_field` AS `CO` 
        ON `CO`.`issue_id` = `Issue`.`issue_id` AND `CO`.`name` = 'Company Objective'
    -- Left join to bring Company Key Result
    LEFT JOIN 
        `jira_issue_field` AS `CKR` 
        ON `CKR`.`issue_id` = `Issue`.`issue_id` AND `CKR`.`name` = 'Company Key Result'
    -- Left join to bring Division OKR
    LEFT JOIN 
        `jira_issue_field` AS `DOKR` 
        ON `DOKR`.`issue_id` = `Issue`.`issue_id` AND `DOKR`.`name` = 'Division OKR'
    -- Left join to bring Customer Impact
    LEFT JOIN 
        `jira_issue_field` AS `CI` 
        ON `CI`.`issue_id` = `Issue`.`issue_id` AND `CI`.`name` = 'Customer Impact'
    -- Left join to bring L1 Metric
    LEFT JOIN 
        `jira_issue_field` AS `L1M` 
        ON `L1M`.`issue_id` = `Issue`.`issue_id` AND `L1M`.`name` = 'L1 Metric'
    -- Left join to bring Channel Impact
    LEFT JOIN 
        `jira_issue_field` AS `CIMP` 
        ON `CIMP`.`issue_id` = `Issue`.`issue_id` AND `CIMP`.`name` = 'Channel Impact'
    -- Left join to bring R&D
    LEFT JOIN 
        `jira_issue_field` AS `R&D` 
        ON `R&D`.`issue_id` = `Issue`.`issue_id` AND `R&D`.`name` = 'R&D'
    -- Left join to bring RAG
    LEFT JOIN 
        `jira_issue_field` AS `RAG` 
        ON `RAG`.`issue_id` = `Issue`.`issue_id` AND `RAG`.`name` = 'RAG Status'
	
	


WHERE 
    `Issue`.`issue_type` = 'Initiative'
	-- Condition to filter the query using the calendar control
	AND
	`Issue`.`created_at` BETWEEN {CAL_CREATED_AT.START} AND {CAL_CREATED_AT.END}
	-- Condition to filter the query using the dropdown status control
	AND
	{DROPDOWN_STATUS.IN('`Issue`.`status`')}
	-- Condition to filter the query using the dropdown project control
	AND
	{DROPDOWN_PROJECT.IN('`PR`.`project_key`')}

GROUP BY
	`PR`.`project_key`

LIMIT 3000;