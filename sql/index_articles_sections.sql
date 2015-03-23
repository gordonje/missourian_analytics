
CREATE INDEX articles_sections_article_id ON articles_sections (article_id);

CREATE INDEX articles_sections_pub_time ON articles_sections (pub_time);

CREATE INDEX articles_sections_article_slug ON articles_sections (article_slug);

CREATE INDEX articles_sections_status ON articles_sections (status);

CREATE INDEX articles_sections_section_id ON articles_sections (section_id);

CREATE INDEX articles_sections_is_active ON articles_sections (is_active);

CREATE INDEX articles_sections_parent_section_id ON articles_sections (parent_section_id);

CREATE INDEX articles_sections_parent_is_active ON articles_sections (parent_is_active);
