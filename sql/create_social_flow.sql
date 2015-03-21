
CREATE TABLE social_flow ( 
          Account_Name VARCHAR(255)
        , Account_Type VARCHAR(255)
        , Created_By VARCHAR(255)
        , Publish_Date DATE
        , Time_UTC TIME
        , Message VARCHAR(8000)
        , Publish_Status VARCHAR(255)
        , Labels VARCHAR(255)
        , Clicks BIGINT
        , Retweets_Shares BIGINT
        , Likes_Favorites_plus1s BIGINT
        , Comments BIGINT
        , Reach VARCHAR(255)
        , Link VARCHAR(255)
);