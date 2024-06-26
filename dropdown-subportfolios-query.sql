SELECT
    "Subportfolios"."Label" AS "Subportfolio"
FROM
    "GoogleSheets"."Xero_subportfolios_Atlassian_Analytics_Data_Source_Subportfolios" AS "Subportfolios"
WHERE
    "Subportfolios"."Project_Key" IS NOT NULL
    AND "Subportfolios"."Show_in_dashboard" = 'Yes'
GROUP BY
    "Label"
ORDER BY
    "Label" ASC
LIMIT
    1000;