module GamedayApi
  # This class represents a single MLB game
  class MilbGame

    attr_accessor :gid, :home_team_name, :home_team_abbrev, :visit_team_name, :visit_team_abbrev,
                  :year, :month, :day, :game_number, :visiting_team, :home_team, :stadium_id
    attr_accessor :boxscore, :rosters, :eventlog, :media, :date

    attr_accessor :innings #array of Inning objects, from innings files

    attr_accessor :players # data from the players.xml file

    # additional attributes from master_scoreboard.xml
    attr_accessor :scoreboard_game_id, :ampm, :venue, :game_pk, :time, :time_zone, :game_type
    attr_accessor :away_name_abbrev, :home_name_abbrev, :away_code, :away_file_code, :away_team_id
    attr_accessor :away_team_city, :away_team_name, :away_division
    attr_accessor :home_code, :home_file_code, :home_team_id, :home_team_city, :home_team_name, :home_division
    attr_accessor :day, :gameday_sw, :away_games_back, :home_games_back, :away_games_back_wildcard, :home_games_back_wildcard
    attr_accessor :venue_w_chan_loc, :gameday, :away_win, :away_loss, :home_win, :home_loss, :league, :home_league, :away_league

    attr_accessor :status  # An instance of GameStatus object
    attr_accessor :homeruns # an array of players with homeruns in the game
    attr_accessor :winning_pitcher, :losing_pitcher, :save_pitcher  # Instances of Player object
    attr_accessor :away_innings, :home_innings  # An arry of one element for each inning, the element is the home or away score
    attr_accessor :home_hits, :away_hits, :home_errors, :away_errors, :home_runs, :away_runs
    attr_accessor :starting_home_catcher_id, :starting_away_catcher_id
    attr_accessor :starting_home_rf_id, :starting_away_rf_id
    attr_accessor :starting_home_lf_id, :starting_away_lf_id
    attr_accessor :starting_home_cf_id, :starting_away_cf_id
    attr_accessor :starting_home_first_id, :starting_away_first_id
    attr_accessor :starting_home_second_id, :starting_away_second_id
    attr_accessor :starting_home_third_id, :starting_away_third_id
    attr_accessor :starting_home_ss_id, :starting_away_ss_id

    def initialize(gid)
      @innings = []
      team = Team.new('')
      if gid
        @gid = gid
        @xml_data = GamedayFetcher.fetch_milb_game_xml(gid)
        if @xml_data && @xml_data.size > 0
          @xml_doc = REXML::Document.new(@xml_data)
          @game_type = @xml_doc.root.attributes["type"]
          @time = @xml_doc.root.attributes["local_game_time"]
          info = GamedayUtil.parse_gameday_id('gid_'+gid)
          @home_team_abbrev = info["home_team_abbrev"]
          @stadium_id = @xml_doc.root.elements['stadium'].attributes['id']
          @visit_team_abbrev = info["visiting_team_abbrev"]
          @visiting_team = Team.new(@visit_team_abbrev )
          @home_team = Team.new(@home_team_abbrev )
          @year = info["year"]
          @month = info["month"]
          @day = info["day"]
          @game_number = info["game_number"]
          @home_league = @xml_doc.root.elements['team[1]'].attributes['league']
          @away_league = @xml_doc.root.elements['team[2]'].attributes['league']

          if Team.teams[@home_team_abbrev]
            @home_team_name = Team.teams[@home_team_abbrev][0]
          else
            @home_team_name = @home_team_abbrev
          end
          if Team.teams[@visit_team_abbrev]
            @visit_team_name = Team.teams[@visit_team_abbrev][0]
          else
            @visit_team_name = @visit_team_abbrev
          end
        else
          raise ArgumentError, "Could not find game.xml"
        end
      end
    end


    # Setup a Game object from data read from the  master_scoreboard.xml file
    def load_from_scoreboard(element)
        @away_innings = []
        @home_innings = []
        @scoreboard_game_id = element.attributes['id']
        @ampm = element.attributes['ampm']
        @venue = element.attributes['venue']
        @game_pk = element.attributes['game_pk']
        @time = element.attributes['time']
        @time_zone = element.attributes['time_zone']
        @game_type = element.attributes['game_type']
        @away_name_abbrev = element.attributes['away_name_abbrev']
        @home_name_abbrev = element.attributes['home_name_abbrev']
        @away_code = element.attributes['away_code']
        @away_file_code = element.attributes['away_file_code']
        @away_team_id = element.attributes['away_team_id']
        @away_team_city = element.attributes['away_team_city']
        @away_team_name = element.attributes['away_team_name']
        @away_division = element.attributes['away_division']
        @home_code = element.attributes['home_code']
        @home_file_code = element.attributes['home_file_code']
        @home_team_id = element.attributes['home_team_id']
        @home_team_city = element.attributes['home_team_city']
        @home_team_name = element.attributes['home_team_name']
        @home_division = element.attributes['home_division']
        @day = element.attributes['day']
        @gameday_sw = element.attributes['gameday_sw']
        @away_games_back = element.attributes['away_games_back']
        @home_games_back = element.attributes['home_games_back']
        @away_games_back_wildcard = element.attributes['away_games_back_wildcard']
        @home_games_back_wildcard = element.attributes['home_games_back_wildcard']
        @venue_w_chan_loc = element.attributes['venue_w_chan_loc']
        @gameday = element.attributes['gameday']
        @away_win = element.attributes['away_win']
        @away_loss = element.attributes['away_loss']
        @home_win = element.attributes['home_win']
        @home_loss = element.attributes['home_loss']
        @league = element.attributes['league']

        set_status(element)
        set_innings(element)
        set_totals(element)
        set_pitchers(element)
        set_homeruns(element)
        set_starting_players
      end


      # Sets the game status from data in the master_scoreboard.xml file
      def set_status(element)
        element.elements.each("status") { |status|
          @status = GameStatus.new
          @status.status = status.attributes['status']
          @status.ind = status.attributes['ind']
          @status.reason = status.attributes['reason']
          @status.inning = status.attributes['inning']
          @status.top_inning = status.attributes['top_inning']
          @status.b = status.attributes['b']
          @status.s = status.attributes['s']
          @status.o = status.attributes['o']
        }
      end

      def set_starting_players
        rosters = get_rosters
        away_roster = rosters[0]
        home_roster = rosters[1]
        @starting_home_catcher_id = home_roster.players.find {|p| p if p.game_position=='C'}.pid
        @starting_away_catcher_id = away_roster.players.find {|p| p if p.game_position=='C'}.pid
        @starting_home_first_id = home_roster.players.find {|p| p if p.game_position=='1B'}.pid
        @starting_away_first_id = away_roster.players.find {|p| p if p.game_position=='1B'}.pid
        @starting_home_second_id = home_roster.players.find {|p| p if p.game_position=='2B'}.pid
        @starting_away_second_id = away_roster.players.find {|p| p if p.game_position=='2B'}.pid
        @starting_home_third_id = home_roster.players.find {|p| p if p.game_position=='3B'}.pid
        @starting_away_third_id = away_roster.players.find {|p| p if p.game_position=='3B'}.pid
        @starting_home_ss_id = home_roster.players.find {|p| p if p.game_position=='SS'}.pid
        @starting_away_ss_id = away_roster.players.find {|p| p if p.game_position=='SS'}.pid
        @starting_home_lf_id = home_roster.players.find {|p| p if p.game_position=='LF'}.pid
        @starting_away_lf_id = away_roster.players.find {|p| p if p.game_position=='LF'}.pid
        @starting_home_cf_id = home_roster.players.find {|p| p if p.game_position=='CF'}.pid
        @starting_away_cf_id = away_roster.players.find {|p| p if p.game_position=='CF'}.pid
        @starting_home_rf_id = home_roster.players.find {|p| p if p.game_position=='RF'}.pid
        @starting_away_rf_id = away_roster.players.find {|p| p if p.game_position=='RF'}.pid
      end


      # Sets the away and home innings array containing scores by inning from data in the master_scoreboard.xml file
      def set_innings(element)
        element.elements.each("linescore/inning") { |element|
           @away_innings << element.attributes['away']
           @home_innings << element.attributes['home']
        }
      end


      # Sets the Runs/Hits/Errors totals from data in the master_scoreboard.xml file
      def set_totals(element)
        element.elements.each("linescore/r") { |runs|
           @away_runs = runs.attributes['away']
           @home_runs = runs.attributes['home']
        }
        element.elements.each("linescore/h") { |hits|
           @away_hits = hits.attributes['away']
           @home_hits = hits.attributes['home']
        }
        element.elements.each("linescore/e") { |errs|
           @away_errors = errs.attributes['away']
           @home_errors = errs.attributes['home']
        }
      end


      # Sets a list of players who had homeruns in this game from data in the master_scoreboard.xml file
      def set_homeruns(element)
        @homeruns = []
        element.elements.each("home_runs/player") do |hr|
          player = Player.new
          player.last = hr.attributes['last']
          player.first = hr.attributes['first']
          player.hr = hr.attributes['hr']
          player.std_hr = hr.attributes['std_hr']
          player.team_code = hr.attributes['team_code']
          @homeruns << player
        end
      end


    # Sets the pitchers of record (win, lose, save) from data in the master_scoreboard.xml file
    def set_pitchers(element)
      element.elements.each("winning_pitcher") do |wp|
        @winning_pitcher = Player.new
        @winning_pitcher.init_pitcher_from_scoreboard(wp)
      end
      element.elements.each("losing_pitcher") do |lp|
        @losing_pitcher = Player.new
        @losing_pitcher.init_pitcher_from_scoreboard(lp)
      end
      element.elements.each("save_pitcher") do |sp|
        @save_pitcher = Player.new
        @save_pitcher.first = sp.attributes['first']
        @save_pitcher.last = sp.attributes['last']
        @save_pitcher.saves = sp.attributes['saves']
      end
    end


    def self.find_by_month(year, month)
      games = []
      start_date = Date.new(year.to_i, month.to_i) # first day of month
      end_date = (start_date >> 1)-1 # last day of month
      ((start_date)..(end_date)).each do |dt|
        games += find_by_date(year, month, dt.day.to_s)
      end
      games
    end


    # Returns an array of Game objects for each game for the specified day
    def self.find_by_date(year, month, day)
      puts '########### Game.find_by_date'
      begin
        games = []
        games_page = GamedayFetcher.fetch_milb_games_page(year, month, day)
        if games_page
          @hp = Hpricot(games_page)
          a = @hp.at('ul')
          (a/"a").each do |link|
            # look at each link inside of a ul tag
            if link.inner_html.include?('gid')#  &&
               #link.inner_html.include?(GamedayUtil.convert_digit_to_string(month) + '_' + GamedayUtil.convert_digit_to_string(day))
              # if the link contains the text 'gid' and matches correct date
              # then it is a game listing for the correct date
              str = link.inner_html
              gid = str[5..str.length-2]
              begin
                game = MilbGame.new(gid)
                games.push game
              rescue Exception => err
                puts "err: #{err}"
                puts "Could not create game object for #{year}, #{month}, #{day} - #{gid}"
              end
            end
          end
        else
          puts "Could not read games page for #{year}, #{month}, #{day}."
        end
        return games
      rescue
        puts "No games data found for #{year}, #{month}, #{day}."
      end
    end


    # Returns a 2 element array containing the home and visiting rosters for this game
    #    [0] array of all visitor players
    #    [1] array of all home players
    def get_rosters
      if !@rosters
        players = MilbPlayers.new
        players.load_from_id(@gid)
        @rosters = players.rosters
      end
      @rosters
    end


    def get_eventlog
      if !@eventlog
        @eventlog = EventLog.new
        @eventlog.load_from_id(@gid)
      end
      @eventlog
    end


    # Returns a BoxScore object representing the boxscore for this game
    def get_boxscore
      if !@boxscore
        box = MilbBoxScore.new
        box.load_from_id(self.gid)
        @boxscore = box
      end
      puts "GOT BOXSCORE: #{@boxscore.inspect}"
      @boxscore
    end


    # Saves an HTML version of the boxscore for the game
    def dump_boxscore
      if self.gid
        bs = get_boxscore
        GamedayUtil.save_file("boxscore.html", bs.to_html('boxscore.html.erb'))
      else
        puts "No data for input specified"
      end
    end


    # Returns a string containing the linescore in the following printed format:
    #   Away 1 3 1
    #   Home 5 8 0
    def print_linescore
    	bs = get_boxscore
    	output = ''
    	if bs.linescore
      	output += self.visit_team_name + ' ' + bs.linescore.away_team_runs + ' ' + bs.linescore.away_team_hits + ' ' + bs.linescore.away_team_errors + "\n"
      	output += self.home_team_name + ' ' + bs.linescore.home_team_runs + ' ' + bs.linescore.home_team_hits + ' ' + bs.linescore.home_team_errors
      else
      	output += 'No linescore available for ' + @visit_team_name + ' vs. ' + @home_team_name
      end
      output
    end


    # Returns an array of the starting pitchers for the game
    #    [0] = visiting team pitcher
    #    [1] = home team pitcher
    def get_starting_pitchers
      results = []
      results << get_pitchers('away')[0]
      results << get_pitchers('home')[0]
    end


    # Returns an array of the closing pitchers for the game
    #    [0] = visiting team pitcher
    #    [1] = home team pitcher
    def get_closing_pitchers
      results = []
      away_pitchers = get_pitchers('away')
      home_pitchers = get_pitchers('home')
      results << away_pitchers[(away_pitchers.size) - 1]
      results << home_pitchers[(home_pitchers.size) -1]
    end


    # Returns an array of all pitchers for either the home team or the away team.
    # The values in the returned array are PitchingAppearance instances
    def get_pitchers(home_or_away)
      if self.gid
        bs = get_boxscore
        if home_or_away == 'away'
          bs.pitchers[0]
        else
          bs.pitchers[1]
        end
      else
        puts "No data for input specified"
      end
    end


    # Returns an array of pitches from this game for the pitcher identified by pid
    def get_pitches(pid)
      results = []
      atbats = get_atbats
      atbats.each do |ab|
        if ab.pitcher_id == pid
          results << ab.pitches
        end
      end
      results.flatten
    end


    # Returns an array of either home or away batters for this game
    # home_or_away must be a string with value 'home' or 'away'
    # The values in the returned array are BattingAppearance instances
    def get_batters(home_or_away)
      if self.gid
        bs = get_boxscore
        if home_or_away == 'away'
        	bs.batters[0]
        else
          bs.batters[1]
        end
      else
        puts "No data for input specified"
      end
    end


    # Returns the starting lineups for this game in an array with 2 elements
    # results[0] = visitors
    # results[1] = home
    def get_lineups
      results = []
      results << get_batters('away')
      results << get_batters('home')
    end


    # Returns the pitchers for this game in an array with 2 elements
    # results[0] = visitors
    # results[1] = home
    def get_pitching
      results = []
      results << get_pitchers('away')
      results << get_pitchers('home')
    end


    # Returns the team abreviation of the winning team
    def get_winner
      ls = get_boxscore.linescore
      if ls.home_team_runs > ls.away_team_runs
        return home_team_abbrev
      else
        return visit_team_abbrev
      end
    end


    # Returns a 2 element array holding the game score
    #    [0] visiting team runs
    #    [1] home team runs
    def get_score
      results = []
      ls = get_boxscore.linescore
      results << ls.away_team_runs
      results << ls.home_team_runs
      results
    end


    # Returns a string holding the game attendance value
    def get_attendance
      game_info = get_boxscore.game_info
      # parse game_info to get attendance
      game_info[game_info.length-12..game_info.length-7]
    end


    def get_media
      if !@media
        @media = Media.new
        @media.load_from_id(@gid)
      end
      @media
    end


    # Returns an array of Inning objects that represent each inning of the game
    def get_innings
      if @innings.length == 0
        inn_count = get_num_innings
        (1..get_num_innings).each do |inn|
          inning = MilbInning.new
          inning.load_from_id(@gid, inn)
          @innings << inning
        end
      end
      @innings
    end


    # Returns an array of AtBat objects that represent each atbat of the game
    def get_atbats
      atbats = []
      innings = get_innings
      innings.each do |inning|
        inning.top_atbats.each do |atbat|
          atbat.is_top = 1
          atbats << atbat
        end
        inning.bottom_atbats.each do |atbat|
          atbat.is_top = 0
          atbats << atbat
        end
      end
      atbats
    end

    def get_actions
      actions = []
      innings = get_innings
      innings.each do |inning|
        inning.top_actions.each do |action|
          actions << action
        end
        inning.bottom_actions.each do |action|
          actions << action
        end
      end
      actions
    end


    def get_hitchart
      if !@hitchart
        @hitchart = Hitchart.new
        @hitchart.load_from_gid(@gid)
      end
      @hitchart
    end


    # Returns the number of innings for this game
    def get_num_innings
      bs = get_boxscore
      if bs.linescore
        return get_boxscore.linescore.innings.length
      else
        return 0
      end
    end


    # Returns a hash of umpires for this game
    #
    #   { 'hp' => 'john doe',
    #     '1b' => 'paul jones',
    #     '2b' => 'mike james',
    #     '3b' => 'pete myers' }
    #
    def get_umpires
      if !@players
        @players = MilbPlayers.new
        @players.load_from_id(@gid)
      end
      @players.umpires
    end


    def get_date
      bs = get_boxscore
      bs.date
    end


    def get_temp
      bs = get_boxscore
      bs.temp
    end


    def get_wind_speed
      bs = get_boxscore
      bs.wind_speed
    end


    def get_wind_dir
      bs = get_boxscore
      bs.wind_dir
    end

    def get_dome
      bs = get_boxscore
      bs.dome
    end


    def get_home_runs
      bs = get_boxscore
      bs.home_runs
    end


    def get_away_runs
      bs = get_boxscore
      bs.away_runs
    end


    def official?
      ((@game_type == 'R' || @game_type == 'L') && get_boxscore.status_ind != 'P')
    end


  end
end

