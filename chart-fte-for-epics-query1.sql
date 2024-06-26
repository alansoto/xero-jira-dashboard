SELECT 
   `PR`.`project_key`,
	
	
	SUM(
		COALESCE(CAST(`EFTE`.`value` as FLOAT),0) + 
	    COALESCE(CAST(`DFTE`.`value` AS FLOAT),0) + 
	    COALESCE(CAST(`PFTE`.`value` AS FLOAT),0) 
    ) AS `Total FTE`
	
FROM 
    `jira_issue` AS `Issue`
    INNER JOIN 
        `jira_project` AS `PR` ON `PR`.`project_id` = `Issue`.`project_id`
    -- Left join to bring Division OKR
    LEFT JOIN 
        `jira_issue_field` AS `DOKR` 
        ON `DOKR`.`issue_id` = `Issue`.`issue_id` AND `DOKR`.`name` = 'Division OKR'
    -- Left join to bring Customer Impact
    LEFT JOIN 
        `jira_issue_field` AS `CI` 
        ON `CI`.`issue_id` = `Issue`.`issue_id` AND `CI`.`name` = 'Customer Impact'
    -- Left join to bring Product FTE
    LEFT JOIN 
        `jira_issue_field` AS `PFTE` 
        ON `PFTE`.`issue_id` = `Issue`.`issue_id` AND `PFTE`.`name` = 'Product FTE'
    -- Left join to bring Design FTE
    LEFT JOIN 
        `jira_issue_field` AS `DFTE` 
        ON `DFTE`.`issue_id` = `Issue`.`issue_id` AND `DFTE`.`name` = 'Design FTE'
    -- Left join to bring Engineering FTE
    LEFT JOIN 
        `jira_issue_field` AS `EFTE` 
        ON `EFTE`.`issue_id` = `Issue`.`issue_id` AND `EFTE`.`name` = 'Engineering FTE'
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
    -- Left join to bring TOD
    LEFT JOIN 
        `jira_issue_field` AS `TOD` 
        ON `TOD`.`issue_id` = `Issue`.`issue_id` AND `TOD`.`name` = 'Taxonomy of Demand'
    -- Left join to bring Start Date
    LEFT JOIN 
        `jira_issue_field` AS `SD` 
        ON `SD`.`issue_id` = `Issue`.`issue_id` AND `SD`.`name` = 'Start date'
    -- Left join to bring Due Date
    LEFT JOIN 
        `jira_issue_field` AS `DD` 
        ON `DD`.`issue_id` = `Issue`.`issue_id` AND `DD`.`name` = 'Due date'
    
    -- Left join to bring Parent
    LEFT JOIN `jira_issue` AS `Parent` ON `Issue`.`parent_issue_id` = `Parent`.`issue_id` 


WHERE 
    `Issue`.`issue_type` = 'Epic'
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