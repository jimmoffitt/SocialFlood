=begin

Set of methods that return SQL for pulling (non-Twitter) event data from relational database.

This class knows nothing about database connections.
This class does NOT know how to bin time interval data.

Methods here know about:
* Lists of numeric site IDs.
* A params hash that provides various metadata for fetching data. Such as:
    - start and end times for time periods of interest. (YYYY-MM-DD HH:mm:ss)


Based on this hydro db schema:

Site metadata:

CREATE TABLE `sites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `site_id` int(11) NOT NULL,
  `lat` double NOT NULL,
  `long` double NOT NULL,
  `altitude` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Time-series event data.

Rain measurements:

CREATE TABLE `rainvalues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `posted_at` datetime NOT NULL,
  `site_id` int(11) unsigned NOT NULL,
  `sensor_id` int(11) unsigned DEFAULT NULL,
  `incr_15` float DEFAULT NULL,
  `accum` float DEFAULT NULL,
  `accum_event` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103681 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


Water-level measurements: (stage)
CREATE TABLE `stagevalues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `posted_at` datetime DEFAULT NULL,
  `site_id` int(11) unsigned NOT NULL,
  `sensor_id` int(11) unsigned DEFAULT NULL,
  `max_15` float DEFAULT NULL,
  `avg_15` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51841 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

=end

class HydroSQL
  
  #Pulls site metadata for specified site list.
  #site_list is an array of comma-separated numeric site_ids.
  #db type: `site_id` int(11) NOT NULL

  def get_sites_sql(site_list)
    sSQL = "SELECT `site_id`, `name`, `lat`, `long`, `altitude`
    FROM sites
    WHERE `site_id` IN (#{site_list})
    ORDER BY `site_id` ASC;"
  end
  
  #These pull event data. Non-binned time-series data.
  #Owner of this class would need to perform any needed time interval binning.
  #site_list is an array of comma-separated numeric site_ids.
  #db type: `site_id` int(11) NOT NULL
  
  def get_rain_data_sql(site_list, params)
    sSQL = "SELECT s.`name`, v.`site_id`, v.`posted_at`, v.`incr_15`, v.`accum_event`
    FROM sites s, rainvalues v
    WHERE v.`site_id` IN (#{site_list})
      AND v.`site_id` = s.`site_id`
      AND v.`posted_at` > '#{params[:start_date]}'
      AND v.`posted_at` <=  '#{params[:end_date]}'
    ORDER BY v.`posted_at` ASC;"
  end

  def get_stage_data_sql(site_list, params)
    sSQL = "SELECT s.`name`, v.`site_id`, v.`posted_at`, v.`avg_15`
    FROM sites s, stagevalues v
    WHERE v.`site_id` IN (#{site_list})
      AND v.`site_id` = s.`site_id`
      AND v.`posted_at` > '#{params[:start_date]}'
      AND v.`posted_at` < '#{params[:end_date]}'
    ORDER BY v.`posted_at` ASC;"
  end
  
end