require 'gameday_api/pitch'

module GamedayApi
  # This class represents a single atbat during a single game
  class AtBat
  
    attr_accessor :gid, :inning, :away_team, :home_team, :is_top
    attr_accessor :num, :b, :s, :o, :batter_id, :stand, :b_height, :pitcher_id, :p_throws, :des, :event
    attr_accessor :pitches
    attr_accessor :home_starting_pitcher_id, :visiting_starting_pitcher_id
  
    def init(element, gid, inning, is_top)
      @inning = inning
      @xml_doc = element
    	@gid = gid
    	@num = element.attributes["num"]
      @is_top = is_top
    	@b = element.attributes["b"]
    	@s = element.attributes["s"]
    	@o = element.attributes["o"]
    	@batter_id = element.attributes["batter"]
    	@stand = element.attributes["stand"]
    	@b_height = element.attributes["b_height"]
    	@pitcher_id = element.attributes["pitcher"]
    	@p_throws = element.attributes["p_throws"]
    	@des = element.attributes["des"]
    	@event = element.attributes["event"] 	
    	set_pitches(element)
    end
  
  
    def set_pitches(element)
    	@pitches = []
      element.elements.each("pitch") do |element| 
      	pitch = Pitch.new
      	pitch.init(element)
      	@pitches << pitch
      end
    end
  
  
  end
end