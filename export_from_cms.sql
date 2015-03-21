SELECT 
        article_id
      , core_article.hed
      , section_id
      , core_section.hed as section_name
      , core_section.is_active
      , core_section.paywall
      , core_section.paywall_always
      , core_section.parent_id as parent_section_id
      , parent_section.hed as parent_hed
      , parent_section.is_active as parent_is_active
      , parent_section.paywall as parent_paywall
      , parent_section.paywall_always as parent_paywall_always
INTO OUTFILE '/Users/gordo/missourian_analytics/data/cms_data.csv' -- replace w/ your own file path
      FIELDS TERMINATED BY '|' 
      ENCLOSED BY '"' ESCAPED BY '\\'
      LINES TERMINATED BY "\n"
FROM core_article
JOIN core_article_sections
ON core_article.id = core_article_sections.article_id
JOIN core_section
ON section_id = core_section.id
LEFT JOIN core_section as parent_section
ON core_section.parent_id = parent_section.id;