SELECT 
	`PR`.`project_key`,
    `Issue`.`issue_key` AS `Issue key`,
    `Issue`.`summary` AS `Summary`,
	`Issue`.`created_at` AS `Created`,
	`Issue`.`status` AS `Status`,
	`Issue`.`url` AS `URL`,
	
	-- Calculation of Jira Data Completeness Index
    (
        CASE WHEN `PFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	    CASE WHEN `EFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
        CASE WHEN `DFTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `DOKR`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `CI`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `L1M`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `CIMP`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `R&D`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `RAG`.`value` IS NULL THEN 0 ELSE 0.0714 END +
		CASE WHEN `TOD`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	   CASE WHEN `SDTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	   CASE WHEN `DDTE`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `REG`.`value` IS NULL THEN 0 ELSE 0.0714 END +
	  	CASE WHEN `Issue`.`parent_issue_id` IS NULL THEN 0 ELSE 0.0772 END
    )  AS `JDCI`,
	
	`DOKR`.`value` AS `Division OKR`,
	`CI`.`value` AS `Customer Impact`,
	`PFTE`.`value` AS `Product FTE`,
	`DFTE`.`value` AS `Design FTE`,
    `EFTE`.`value` AS `Engineering FTE`,
	CAST(`EFTE`.`value` as FLOAT) + CAST(`DFTE`.`value` AS FLOAT)+ CAST(`PFTE`.`value` AS FLOAT) AS `Total FTE`,
	`L1M`.`value` AS `L1 Metric`,
	`CIMP`.`value` AS `Channel Impact`,
	`R&D`.`value` AS `R&D`,
	`RAG`.`value` AS `RAG Status`,
	`TOD`.`value` AS `Taxonomy of Demand`,
	`SDTE`.`value` AS `Start date`,
	`DDTE`.`value` AS `Due date`,
	`REG`.`value` AS `Regions Impacted`,
	`PAR`.`url` AS `Parent URL`,
	`PAR`.`issue_key` AS `Parent Issue Key`
	
FROM 
    `jira_issue` AS `Issue`
INNER JOIN 
	`jira_project` AS `PR` ON `PR`.`project_id` = `Issue`.`project_id`
-- Left join to bring Product FTE
LEFT JOIN 
    `jira_issue_field` AS `PFTE` 
    ON `PFTE`.`issue_id` = `Issue`.`issue_id` AND `PFTE`.`name` = 'Product FTE'
-- Left join to bring Engineering FTE
LEFT JOIN 
    `jira_issue_field` AS `EFTE` 
    ON `EFTE`.`issue_id` = `Issue`.`issue_id` AND `EFTE`.`name` = 'Engineering FTE'
-- Left join to bring Design FTE
LEFT JOIN 
    `jira_issue_field` AS `DFTE` 
    ON `DFTE`.`issue_id` = `Issue`.`issue_id` AND `DFTE`.`name` = 'Design FTE'
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
-- Left join to bring REG	
LEFT JOIN 
    `jira_issue_field` AS `REG` 
    ON `REG`.`issue_id` = `Issue`.`issue_id` AND `REG`.`name` = 'Regions Impacted'
-- Left join to bring TOD	
LEFT JOIN 
    `jira_issue_field` AS `TOD` 
    ON `TOD`.`issue_id` = `Issue`.`issue_id` AND `TOD`.`name` = 'Taxonomy of Demand'
-- Left join to bring SDTE	
LEFT JOIN 
    `jira_issue_field` AS `SDTE` 
    ON `SDTE`.`issue_id` = `Issue`.`issue_id` AND `SDTE`.`name` = 'Start date'
-- Left join to bring SDTE	
LEFT JOIN 
    `jira_issue_field` AS `DDTE` 
    ON `DDTE`.`issue_id` = `Issue`.`issue_id` AND `DDTE`.`name` = 'Due date'
-- Left join to bring Parent	
LEFT JOIN 
    `jira_issue` AS `PAR` 
    ON `PAR`.`issue_id` = `Issue`.`parent_issue_id`

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
LIMIT 4000;