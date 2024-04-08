SELECT 
	`PR`.`project_key`,
    `Issue`.`issue_key` AS `Issue key`,
    `Issue`.`summary` AS `Summary`,
	`Issue`.`created_at` AS `Created`,
	`Issue`.`status` AS `Status`,
	`Issue`.`url` AS `URL`,
	
	-- Calculation of Jira Data Completeness Index
    (
        CASE WHEN `CO`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `DOKR`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `CI`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `L1M`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `CIMP`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `R&D`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `RAG`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `REG`.`value` IS NULL THEN 0 ELSE 0.125 END
    )  AS `JDCI`,
	
	
	
    `CO`.`value` AS `Company Objective (FY25)`,
	`DOKR`.`value` AS `Division OKR`,
	`CI`.`value` AS `Customer Impact`,
	`L1M`.`value` AS `L1 Metric`,
	`CIMP`.`value` AS `Channel Impact`,
	`R&D`.`value` AS `R&D`,
	`RAG`.`value` AS `RAG Status`,
	`REG`.`value` AS `Regions Impacted`,
	
	-- FTE Aggreagation
	SUM (COALESCE((CAST(`PFTE`.`value` AS FLOAT)) ,0))+
	SUM (COALESCE((CAST(`EFTE`.`value` AS FLOAT)) ,0))+
	SUM (COALESCE((CAST(`DFTE`.`value` AS FLOAT)) ,0)) AS `Total FTE`
    
    
	
FROM 
    `jira_issue` AS `Issue`
INNER JOIN 
	`jira_project` AS `PR` ON `PR`.`project_id` = `Issue`.`project_id`
-- Left join to bring Company Objective
LEFT JOIN 
    `jira_issue_field` AS `CO` 
    ON `CO`.`issue_id` = `Issue`.`issue_id` AND `CO`.`name` = 'Company OKR (FY25)'
-- Left join to bring Division OKR
LEFT JOIN 
    `jira_issue_field` AS `DOKR` 
    ON `DOKR`.`issue_id` = `Issue`.`issue_id` AND `DOKR`.`name` IN ('SB & Growth Division OKR / Deliverable', 'Ecosystem Division OKR / Deliverable')
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
-- Left join to bring REG	
LEFT JOIN 
    `jira_issue_field` AS `REG` 
    ON `REG`.`issue_id` = `Issue`.`issue_id` AND `REG`.`name` = 'Regions Impacted' AND `REG`.`field_key` = 'customfield_15209'

-- Series of JOINS to bring FTE values
INNER JOIN `jira_issue` AS `Epic` 
	ON `Issue`.`issue_id` = `Epic`.`parent_issue_id`
LEFT JOIN 
	`jira_issue_field` AS `PFTE` 
    ON `PFTE`.`issue_id` = `Epic`.`issue_id` AND `PFTE`.`name` = 'Product FTE'
LEFT JOIN 
   `jira_issue_field` AS `EFTE` 
   ON `EFTE`.`issue_id` = `Epic`.`issue_id` AND `EFTE`.`name` = 'Engineering FTE'
LEFT JOIN 
   `jira_issue_field` AS `DFTE` 
   ON `DFTE`.`issue_id` = `Epic`.`issue_id` AND `DFTE`.`name` = 'Design FTE'

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
	`PR`.`project_key`,
    `Issue`.`issue_key`,
    `Issue`.`summary`,
	`Issue`.`created_at`,
	`Issue`.`status` ,
	`Issue`.`url` ,
	
	-- Calculation of Jira Data Completeness Index
    (
        CASE WHEN `CO`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `DOKR`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `CI`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `L1M`.`value` IS NULL THEN 0 ELSE 0.125 END +
		CASE WHEN `CIMP`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `R&D`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `RAG`.`value` IS NULL THEN 0 ELSE 0.125 END +
	  	CASE WHEN `REG`.`value` IS NULL THEN 0 ELSE 0.125 END
    )  ,
	
	
	
    `CO`.`value` ,
	`DOKR`.`value` ,
	`CI`.`value` ,
	`L1M`.`value` ,
	`CIMP`.`value` ,
	`R&D`.`value` ,
	`RAG`.`value` ,
	`REG`.`value` 
	

ORDER BY 
    `Issue`.`issue_key` ASC
LIMIT 4000;