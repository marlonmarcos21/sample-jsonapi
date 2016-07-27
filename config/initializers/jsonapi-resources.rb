JSONAPI.configure do |config|
  config.default_paginator                   = :paged
  config.top_level_links_include_pagination  = true
  config.top_level_meta_include_record_count = true
end
