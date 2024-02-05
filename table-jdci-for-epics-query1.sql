SELECT 
	`PR`.`project_key`,
	'https://xero.atlassian.net/browse/'|| `Issue`.`issue_key` AS `URL`,
    `Issue`.`issue_key`  AS `Issue key`,
    `Issue`.`summary` AS `Summary`,
	`Issue`.`created_at` AS `Created`,
	`Issue`.`status` AS `Status`,
	
	
	-- Calculation of Jira Data Completeness Index
    (
        CASE WHEN `DOKR`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `CI`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `PFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `DFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `EFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `L1M`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `CIMP`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `R&D`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `RAG`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `TOD`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `SD`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `TE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `TEAM`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `Parent`.`issue_id` IS NULL THEN 0 ELSE 0.0718 END
    )  AS `JDCI`,
	
	
	
    `DOKR`.`value` AS `Division OKR`,
	`CI`.`value` AS `Customer Impact`,
	`PFTE`.`value` AS `Product FTE`,
	`DFTE`.`value` AS `Design FTE`,
	`EFTE`.`value` AS `Engineering FTE`,
	`L1M`.`value` AS `L1 Metric`,
	`CIMP`.`value` AS `Channel Impact`,
	`R&D`.`value` AS `R&D`,
	`RAG`.`value` AS `RAG Status`,
	`TOD`.`value` AS `Taxonomy of Demand`,
	`SD`.`value` AS `Start date`,
	--`TE`.`value` AS `Target End`,
	--`TEAM`.`value` AS `Team`,
	`Parent`.`issue_key` AS `Parent`
	
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
-- Left join to bring SD
LEFT JOIN 
    `jira_issue_field` AS `SD` 
    ON `SD`.`issue_id` = `Issue`.`issue_id` AND `SD`.`name` = 'Start date'
-- Left join to bring TED
LEFT JOIN 
    `jira_issue_field` AS `TE` 
    ON `TE`.`issue_id` = `Issue`.`issue_id` AND `TE`.`name` = 'Target End'
-- Left join to bring TN
LEFT JOIN 
    `jira_issue_field` AS `TEAM` 
    ON `TEAM`.`issue_id` = `Issue`.`issue_id` AND `TEAM`.`name` = 'Assigned Team'
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
ORDER BY 
    `Issue`.`issue_key` ASC
LIMIT 3000;