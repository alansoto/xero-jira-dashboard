SELECT DISTINCT `jira_issue`.`status` AS `Status`
FROM `jira_issue` 
INNER JOIN `jira_project` ON `jira_issue`.`project_id` = `jira_project`.`project_id`
WHERE 
`jira_issue`.`issue_type` IN ('Initiative','Epic')