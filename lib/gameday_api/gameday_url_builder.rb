require 'gameday_api/gameday'


module GamedayApi

  class GamedayUrlBuilder
  
    def self.build_game_base_url(gid)
      gameday_info = GamedayUtil.parse_gameday_id('gid_' + gid)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + gameday_info['year'] + "/month_" + gameday_info['month'] + "/day_" + gameday_info['day'] + "/gid_"+gid.to_s 
    end
  
  
    def self.build_eventlog_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/eventLog.xml" 
    end
  
  
    def self.build_epg_url(year, month, day)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/epg.xml"
    end
  
  
    def self.build_scoreboard_url(year, month, day)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/master_scoreboard.xml"
    end
  
  
    def self.build_day_highlights_url(year, month, day)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/media/highlights.xml"
    end
  
  
    def self.build_boxscore_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/boxscore.xml" 
    end
  
  
    def self.build_game_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/game.xml" 
    end
  
  
    def self.build_game_events_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/game_events.xml" 
    end
  
  
    def self.build_gamecenter_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/gamecenter.xml" 
    end


    def self.build_linescore_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/linescore.xml" 
    end
  

    def self.build_players_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/players.xml" 
    end
  
  
    def self.build_batter_url(year, month, day, gid, pid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/batters/" +  pid.to_s + '.xml'
    end
  
  
    def self.build_pitcher_url(year, month, day, gid, pid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid+"/pitchers/" +  pid.to_s + '.xml' 
    end

    def self.build_pitcher_byyear_url(year, pid)
      set_date_vars(year, nil, nil)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/pitchers/" +  pid.to_s + '.xml' 
    end
  
  
    def self.build_inningx_url(year, month, day, gid, inning_num)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/inning/inning_#{inning_num}.xml"
    end
  
  
    def self.build_inning_scores_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/inning/inning_Scores.xml"
    end
  
  
    def self.build_inning_hit_url(year, month, day, gid)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_" + @@year.to_s + "/month_" + @@month.to_s + "/day_" + @@day.to_s + "/gid_"+gid.to_s+"/inning/inning_hit.xml"
    end
  

    def self.build_day_url(year, month, day)
      set_date_vars(year, month, day)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_#{@@year}/month_#{@@month}/day_#{@@day}/"
    end
  
  
    def self.build_month_url(year, month)
      set_date_vars(year, month, nil)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_#{@@year}/month_#{@@month}/"
    end

    def self.build_year_url(year)
      set_date_vars(year)
      "#{Gameday::GD2_MLB_BASE}/mlb/year_#{@@year}/"
    end
  
  
    private
  
    def self.set_date_vars(year, month, day)
      @@year = GamedayUtil.convert_digit_to_string(year.to_i)
      @@month = GamedayUtil.convert_digit_to_string(month.to_i)
      if day
        @@day = GamedayUtil.convert_digit_to_string(day.to_i)
      end
    end
  
  
  end
end
