class TimeHelpers

  #Time Helper functions.
  def get_date_string(time)
    begin
      return time.year.to_s + '-' + sprintf('%02i', time.month) + '-' +  sprintf('%02i', time.day) + ' ' + sprintf('%02i', time.hour) + ':' + sprintf('%02i', time.min) + ':' + sprintf('%02i', time.sec)
    rescue
      p 'Error parsing date object.'
    end
  end

  def get_date_object(time_string)
    time = Time.now.utc
    time = Time.parse(time_string.to_s)
    return time
  end

  def get_interval(time_string, interval, specifies)

    #p time_string

    #Create Time object to use its methods.
    time = get_date_object(time_string)

    minutes = time.min
    hours = time.hour

    time_updated = Time.new

    #'2013-09-11 18:32:23'
    if specifies == 'begin' then   #TODO: contains 'begin'

      #if interval = 15
      #--> '2013-09-11 18:30:00'
      p 'Warning: not implemented yet.'

      #if interval = 60
      #--> '2013-09-11 18:00:00'
      #.ago.beginning_of_hour
      p 'Warning: not implemented yet.'

    else
      if interval == 15 then
        #--> '2013-09-11 18:45:00'
        if minutes >= 0 and minutes < 15 then
          time_updated =time.change(:min => 15, :sec => 0)
        end
        if minutes >= 15 and minutes < 30 then
          time_updated =time.change(:min => 30, :sec => 0)
        end

        if minutes >= 30 and minutes < 45 then
          time_updated = time.change(:min => 45, :sec => 0)
        end

        if minutes >= 45 and minutes <= 59 then
          time_updated =time.change(:hour => (hours + 1), :min => 0, :sec => 0)
        end

      elsif interval == 60 then
        #--> '2013-09-11 19:00:00'
        if minutes >= 0 and minutes <= 59 then
          time_updated =time.change(:hour => (hours + 1), :min => 0, :sec => 0)
        end
      end
    end

    interval =  get_date_string(time_updated)
    #p interval

    interval

  end

end