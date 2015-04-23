
-- 
CREATE TABLE articles_stats AS
SELECT 
          articles.*
        , fb_posts_count
        , fb_clicks_sum
        , fb_shares_sum
        , fb_likes_sum
        , fb_comments_sum
        , tw_posts_count
        , tw_clicks_sum
        , tw_retweets_sum
        , tw_favs_sum
        , tw_comments_sum
FROM (
        SELECT article_id, hed, pub_time, article_slug, status, COUNT(*) as sections_count
        FROM articles_sections
        GROUP BY 1, 2, 3, 4, 5
) AS articles
LEFT JOIN (
        SELECT 
                  article_id
                , COUNT(*) as fb_posts_count
                , SUM(clicks) as fb_clicks_sum
                , SUM(retweets_shares) as fb_shares_sum
                , SUM(likes_favorites_plus1s) as fb_likes_sum
                , SUM(comments) as fb_comments_sum 
        FROM social_flow
        JOIN messages_links
        ON social_flow.id = messages_links.message_id
        WHERE social_flow.account_type = 'Facebook'
        GROUP BY article_id
) AS fb
ON articles.article_id = fb.article_id
LEFT JOIN (
        SELECT 
                  article_id
                , COUNT(*) as tw_posts_count
                , SUM(clicks) as tw_clicks_sum
                , SUM(retweets_shares) as tw_retweets_sum
                , SUM(likes_favorites_plus1s) as tw_favs_sum
                , SUM(comments) as tw_comments_sum 
        FROM social_flow
        JOIN messages_links
        ON social_flow.id = messages_links.message_id
        WHERE social_flow.account_type = 'Twitter'
        GROUP BY article_id
) AS tw
ON articles.article_id = tw.article_id
WHERE articles.article_id IN (SELECT article_id FROM messages_links);
