require 'gameday_api/inning'
require 'gameday_api/at_bat'

module GamedayApi
  # This class represents a single action during a single game
  class Action
  
    attr_accessor :gid, :inning, :at_bat_num
    attr_accessor :num, :b, :s, :o, :player_id, :pitcher_id, :p_throws, :des, :event
  
    def init(element, gid, inning, atbat)
      @inning = inning
      @xml_doc = element
      @gid = gid
      @b = element.attributes["b"]
      @s = element.attributes["s"]
      @o = element.attributes["o"] 
      @des = element.attributes["des"]
      @event = element.attributes["event"]  
      @player_id = element.attributes["player"]
      @pitch_number = element.attributes["pitch"]
      @atbat = atbat
      @pitcher_id = @atbat.pitcher_id
      @at_bat_num = @atbat.num
      @p_throws = @atbat.p_throws
    end
  
  
  end
end

