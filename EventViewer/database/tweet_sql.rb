class TweetSql
  
  def get_tweets_with_hashtag(params, hashtag)

     if hashtag.include?('|') then
      tags = hashtag.split('|')

      hashtag_list = tags.map {|str| "'#{str}'"}.join(',')
      hashtag_match = " IN (#{hashtag_list}) "

    elsif hashtag[0,1] == '*' then
      hashtag_match = " LIKE '%#{hashtag[1,hashtag.length]}' "
    else
      hashtag_match = " = '#{hashtag}' "
    end

    sSQL = "SELECT a.`posted_at`
            FROM activities a, hashtags h
            WHERE h.hashtag " + hashtag_match +
             "AND a.tweet_id = h.tweet_id
              AND a.`posted_at` > '#{params[:start_date]}'
              AND a.`posted_at` <= '#{params[:end_date]}'
            ORDER BY a.`posted_at` ASC;"
  end

  def get_non_geo_vit_tweets(params)
    #Get non-geo-tagged VIT tweetss.
    sSQL = "SELECT `posted_at`, `link`, `urls`
          FROM activities
          WHERE `long` IS NULL
            AND `vit` = 1
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
           ORDER BY `posted_at` ASC;"

  end
  
  #-----------------------------------------------------------------------------------------
  def get_geo_tagged_tweets(params)
  
    #Get all geo-tagged tweets.
    sSQL = "SELECT `posted_at`, `link`, `lat`, `long`, `lat_box`, `long_box`, `urls`
          FROM activities
          WHERE `long` IS NOT NULL
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  def get_count_geo_tagged_tweets(params)

    #Get all geo-tagged tweets.
    sSQL = "SELECT COUNT(*)
          FROM activities
          WHERE `long` IS NOT NULL
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  #-----------------------------------------------------------------------------------------
  def get_geo_tagged_tweets_with_media(params)

    #Create geo-tagged tweets.
    sSQL = "SELECT `posted_at`, `link`, `lat`, `long`, `lat_box`, `long_box`, `urls`
          FROM activities
          WHERE `long` IS NOT NULL
            AND `urls` IS NOT NULL
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  def get_count_geo_tagged_tweets_with_media(params)

    #Create geo-tagged tweets.
    sSQL = "SELECT COUNT(*)
          FROM activities
          WHERE `long` IS NOT NULL
            AND `urls` IS NOT NULL
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  #-----------------------------------------------------------------------------------------

  def get_tweets_with_profile_geo_only_by_region(params)
    #Create geo-tagged tweets.
    sSQL = "SELECT a.`posted_at`, a.`tweet_id`, a.`link`, a.`user_id`, a.`body`, users.profile_geo_lat AS `lat`, users.profile_geo_long AS `long`, a.`media`, a.`urls`
          FROM activities a, actors users
          WHERE a.user_id = users.user_id
            AND users.`profile_geo_region` = '#{params[:region]}'
            AND a.`long` IS NULL
            AND a.`posted_at` > '#{params[:start_date]}'
            AND a.`posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
    
  end


  def get_tweets_with_profile_geo_only_by_bounding_box(params)
    #Create geo-tagged tweets.
    sSQL = "SELECT a.`posted_at`, a.`tweet_id`, a.`link`, users.profile_geo_lat AS `lat`, users.profile_geo_long AS `long`, a.`urls`
          FROM activities a, actors users
          WHERE a.user_id = users.user_id
            AND users.`profile_geo_long` > #{params[:profile_west]}
            AND users.`profile_geo_long` < #{params[:profile_east]}
            AND users.`profile_geo_lat` > #{params[:profile_south]}
            AND users.`profile_geo_lat` < #{params[:profile_north]}
            AND a.`verb` = 'post'
            AND a.`long` IS NULL
            AND a.`posted_at` > '#{params[:start_date]}'
            AND a.`posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  def get_tweets_with_media_profile_geo_only_by_bounding_box(params)
    #Create geo-tagged tweets.
    sSQL = "SELECT a.`posted_at`, a.`tweet_id`, a.`link`, users.profile_geo_lat AS `lat`, users.profile_geo_long AS `long`, a.`urls`
          FROM activities a, actors users
          WHERE a.user_id = users.user_id
            AND users.`profile_geo_long` > #{params[:profile_west]}
            AND users.`profile_geo_long` < #{params[:profile_east]}
            AND users.`profile_geo_lat` > #{params[:profile_south]}
            AND users.`profile_geo_lat` < #{params[:profile_north]}
            AND (a.`urls` LIKE '%instagram%' OR a.`urls` LIKE '%twitter.com%')
            AND a.`verb` = 'post'
            AND a.`long` IS NULL
            AND a.`posted_at` > '#{params[:start_date]}'
            AND a.`posted_at` <= '#{params[:end_date]}'
          ORDER BY a.`posted_at` ASC;"
  end

  def get_instagram_tweets_with_profile_geo_only(params)
    #WHERE (`media` IS NOT NULL OR `urls` LIKE '%instagram%')
    #Create geo-tagged tweets with media time-series.
    sSQL = "SELECT a.`posted_at`, a.`tweet_id`, a.`link`, a.`user_id`, a.`body`, users.profile_geo_lat AS `lat`, users.profile_geo_long AS `long`, a.`media`, a.`urls`
          FROM activities a, actors users
          WHERE (a`urls` LIKE '%instagram%')
            AND a.user_id = users.user_id
            AND users.`profile_geo_long` IS NOT NULL
            AND a.`long` IS NULL
            AND a.`posted_at` > '#{params[:start_date]}'
            AND a.`posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  def get_geo_tagged_instagram_tweets(params)
    #WHERE (`media` IS NOT NULL OR `urls` LIKE '%instagram%')
    #Create geo-tagged tweets with media time-series.
    sSQL = "SELECT `posted_at`, `tweet_id`, `link`, `user_id`, `body`, `lat`, `long`, `lat_box`, `long_box`, `media`, `urls`
        FROM activities
            WHERE (`urls` LIKE '%instagram%')
 	        AND `long` IS NOT NULL
 	        AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
        ORDER BY `posted_at` ASC;"
  end

end