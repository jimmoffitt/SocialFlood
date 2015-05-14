class TweetSql

  def get_tweets_count(params)

    #Create geo-tagged tweets.
    sSQL = "SELECT COUNT(*)
          FROM activities
          WHERE `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}';"
  end

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
  def get_geo_tagged_tweets_without_media(params)

    #Create geo-tagged tweets.
    sSQL = "SELECT `posted_at`, `link`, `lat`, `long`, `lat_box`, `long_box`, `urls`
          FROM activities
          WHERE `long` IS NOT NULL
            AND `urls` IS NULL
            AND `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}'
          ORDER BY `posted_at` ASC;"
  end

  def get_count_geo_tagged_tweets_without_media(params)

    #Create geo-tagged tweets.
    sSQL = "SELECT COUNT(*)
          FROM activities
          WHERE `long` IS NOT NULL
            AND `urls` IS NULL
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

  def get_followers_count_ts(params, handle)
    #Custom SQL
    sSQL = "SELECT a.posted_at, a.followers_count
                  FROM SocialFlood_development.activities a,
                    SocialFlood_development.actors u
                  WHERE u.handle LIKE \"%#{handle}%\"
                        AND a.user_id = u.user_id
                        AND a.posted_at > '#{params[:start_date]}'
                        AND a.posted_at <= '#{params[:end_date]}';
      "
  end


  #---------------------------------------------------------------------------------------------
  #Generating 15-minute counts from activities table.
  #These were used to compile time-series data for R plots.
  #Written in support of https://blog.gnip.com/tweeting-rain-part-4-tweets-2013-colorado-flood/
  
  def get_tweet_count_timeseries(params)
    
    seconds = params[:interval] * 60
    
    sSQL = "SELECT FROM_UNIXTIME(
                CEILING(UNIX_TIMESTAMP(`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                , COUNT(*) AS tweets
        FROM SocialFlood_development.activities
        WHERE
            posted_at > '#{params[:start_date]}'
            AND posted_at <= '#{params[:end_date]}'
        GROUP
            BY timeslice
        "
  end

  def get_geo_tagged_tweet_counts(params)

    seconds = params[:interval] * 60
    
    sSQL = "SELECT FROM_UNIXTIME(
                CEILING(UNIX_TIMESTAMP(`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                , COUNT(*) AS mycount
        FROM SocialFlood_development.activities
        WHERE
            posted_at > '#{params[:start_date]}'
            AND posted_at <= '#{params[:end_date]}'
            AND `long` IS NOT NULL
        GROUP
            BY timeslice
        "
  end

  def get_has_media_tweet_counts(params)

    seconds = params[:interval] * 60
    
    sSQL = "SELECT FROM_UNIXTIME(
                CEILING(UNIX_TIMESTAMP(`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                , COUNT(*) AS mycount
        FROM SocialFlood_development.activities
        WHERE
            posted_at > '#{params[:start_date]}'
            AND posted_at <= '#{params[:end_date]}'
            AND (`media` IS NOT NULL OR `urls` LIKE '%instagram%')
        GROUP
            BY timeslice
        "
  end

  def get_geo_tagged_has_media_tweet_counts(params)

    seconds = params[:interval] * 60
    
    sSQL = "SELECT FROM_UNIXTIME(
                CEILING(UNIX_TIMESTAMP(`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                , COUNT(*) AS mycount
        FROM SocialFlood_development.activities
        WHERE
            posted_at > '#{params[:start_date]}'
            AND posted_at <= '#{params[:end_date]}'
            AND `long` IS NOT NULL
            AND (`media` IS NOT NULL OR `urls` LIKE '%instagram%')
        GROUP
            BY timeslice
        "
  end

  def get_followers_count(params, handle)

    seconds = params[:interval] * 60
    
    sSQL = "SELECT FROM_UNIXTIME(
                   CEILING(UNIX_TIMESTAMP(a.`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                    , a.followers_count AS mycount
                FROM activities a, actors u
                WHERE
	                u.handle LIKE \"%#{handle}%\"
                    AND a.user_id = u.user_id
                    AND a.posted_at > '#{params[:start_date]}'
                    AND a.posted_at <= '#{params[:end_date]}'
                GROUP
                    BY timeslice;
        "
  end

  def get_tag_count(params, tag)

    seconds = params[:interval] * 60

    sSQL = "SELECT FROM_UNIXTIME(
                   CEILING(UNIX_TIMESTAMP(a.`posted_at`)/#{seconds})*#{seconds}
                    ) AS timeslice
                    , COUNT(*) AS mycount
                FROM activities a, hashtags h
                WHERE
	                a.tweet_id = h.tweet_id
                    AND a.posted_at > '#{params[:start_date]}'
                    AND a.posted_at <= '#{params[:end_date]}'
	                AND (h.hashtag LIKE \"%#{tag}%\")
                GROUP
                    BY timeslice;
                "
  end

end