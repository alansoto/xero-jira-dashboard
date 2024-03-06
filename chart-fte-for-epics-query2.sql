SELECT
    "Subportfolios"."Project_Key" AS "Project Key"
FROM
    "GoogleSheets"."Xero_subportfolios_Atlassian_Analytics_Data_Source_Subportfolios" AS "Subportfolios"
WHERE
    { DROPDOWN_SUBPORTFOLIOS.IN('"Subportfolios"."Label"') }
GROUP BY
    "Project Key"
ORDER BY
    "Project Key" ASC
LIMIT
    1000;