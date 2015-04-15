module GamedayApi

  # This class represents a single inning of an MLB game
  class Inning

    attr_accessor :gid, :num, :away_team, :home_team, :top_atbats, :bottom_atbats, :top_actions, :bottom_actions
    attr_accessor :home_sp_id, :visiting_sp_id

    # loads an Inning object given a game id and an inning number
    def load_from_id(gid, inning)
      @top_atbats = []
      @bottom_atbats = []
      @top_actions = []
      @bottom_actions = []
      @gid = gid
      begin
        @xml_data = GamedayFetcher.fetch_inningx(gid, inning)
        @xml_data_first_inning = GamedayFetcher.fetch_inningx(gid, 1)
        @xml_first_inning = REXML::Document.new(@xml_data_first_inning)
        @xml_doc = REXML::Document.new(@xml_data)
        if @xml_doc.root
          @num = @xml_doc.root.attributes["num"]
          @away_team = @xml_doc.root.attributes["away_team"]
          @home_team = @xml_doc.root.attributes["home_team"]
          set_home_sp(@xml_first_inning)
          set_visiting_sp(@xml_first_inning)
          set_top_ab
          set_bottom_ab
          set_top_actions
          set_bottom_actions
        end
      rescue Exception => err
        puts "Could not load inning file for #{gid}, inning #{inning.to_s} - #{err.inspect}"
      end
    end


    private

    def set_home_sp(first_inning)
      first_inning.elements.each("inning/top/atbat") { |element|
        @home_sp_id = element.attributes["pitcher"]
      }
    end

    def set_visiting_sp(first_inning)
      first_inning.elements.each("inning/bottom/atbat") { |element|
        @visiting_sp_id = element.attributes["pitcher"]
      }
    end

    def set_top_ab
      @xml_doc.elements.each("inning/top/atbat") { |element|
        atbat = AtBat.new
        atbat.init(element, @gid, @num, 1)
        atbat.home_starting_pitcher_id = @home_sp_id
        atbat.visiting_starting_pitcher_id = @visiting_sp_id
        @top_atbats.push atbat
      }
    end


    def set_bottom_ab
      @xml_doc.elements.each("inning/bottom/atbat") { |element|
        atbat = AtBat.new
        atbat.init(element, @gid, @num, 0)
        atbat.home_starting_pitcher_id = @home_sp_id
        atbat.visiting_starting_pitcher_id = @visiting_sp_id
        @bottom_atbats.push atbat
      }
    end

    def set_top_actions
      @xml_doc.elements.each("inning/top/action") { |element|
       action = Action.new
       at_bat = REXML::XPath.first(element, 'following-sibling::atbat[1]')
       atbat = AtBat.new
       atbat.init(at_bat, @gid, @num, 1)
       action.init(element, @gid, @num, atbat)
       @top_actions.push action
      }
    end

    def set_bottom_actions
      @xml_doc.elements.each("inning/bottom/action") { |element|
       action = Action.new
       at_bat = REXML::XPath.first(element, 'following-sibling::atbat[1]')
       atbat = AtBat.new
       atbat.init(at_bat, @gid, @num, 0)
       action.init(element, @gid, @num, atbat)
       @bottom_actions.push action
      }
    end

  end
end
