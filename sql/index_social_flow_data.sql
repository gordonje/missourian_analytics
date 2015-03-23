
CREATE INDEX messages_hashtags_message_id ON messages_hashtags (message_id);

CREATE INDEX messages_hashtags_hashtag ON messages_hashtags (hashtag);


CREATE INDEX messages_handles_message_id ON messages_handles (message_id);

CREATE INDEX messages_handles_handle ON messages_handles (handle);


CREATE INDEX messages_links_message_id ON messages_links (message_id);

CREATE INDEX messages_links_link ON messages_links (link);

CREATE INDEX messages_links_primary_link ON messages_links (primary_link);


CREATE INDEX social_flow_id ON social_flow (id);

CREATE INDEX social_flow_publish_date ON social_flow (publish_date);

CREATE INDEX social_flow_time_utc ON social_flow (time_utc);

CREATE INDEX social_flow_publish_status ON social_flow (publish_status);

CREATE INDEX social_flow_clicks ON social_flow (clicks);

CREATE INDEX social_flow_retweets_shares ON social_flow (retweets_shares);

CREATE INDEX social_flow_likes_favorites_plus1s ON social_flow (likes_favorites_plus1s);

CREATE INDEX social_flow_comments ON social_flow (comments);

CREATE INDEX social_flow_reach ON social_flow (reach);

CREATE INDEX social_flow_post_length ON social_flow (post_length);

CREATE INDEX social_flow_word_count ON social_flow (word_count);

CREATE INDEX social_flow_day_of_week ON social_flow (day_of_week);

CREATE INDEX social_flow_hour_pubd ON social_flow (hour_pubd);

CREATE INDEX social_flow_has_question ON social_flow (has_question);

CREATE INDEX social_flow_has_exclamation ON social_flow (has_exclamation);

CREATE INDEX social_flow_has_graphic ON social_flow (has_graphic);

CREATE INDEX social_flow_hashtag_count ON social_flow (hashtag_count);

CREATE INDEX social_flow_handle_count ON social_flow (handle_count);

CREATE INDEX social_flow_link_count ON social_flow (link_count);

