
CREATE TABLE IF NOT EXISTS short_to_full_urls (
          short_url VARCHAR(255)
        , num_redirects INT
        , full_url VARCHAR(400)
        , scheme  VARCHAR(255)
        , netloc VARCHAR(255)
        , url_path VARCHAR(400)
        , params VARCHAR(400)
        , query VARCHAR(400)
        , fragment VARCHAR(400)
);

