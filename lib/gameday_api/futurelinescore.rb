module GamedayApi

  # This class contains data representing a linescore for a single game not yet played.
  class FutureLineScore

    attr_accessor :xml_doc
    attr_accessor :home_team_name, :away_team_name, :home_team_abbr, :away_team_abbr
    attr_accessor :home_pitcher, :away_pitcher, :venue

    def load_from_id(gid)
      @gid = gid
      @xml_data = GamedayFetcher.fetch_linescore(gid)
      @xml_doc = REXML::Document.new(@xml_data)

      @venue = @xml_doc.root.attributes["venue"]
      @home_team_name = @xml_doc.root.attributes["home_team_name"]
      @away_team_name = @xml_doc.root.attributes["away_team_name"]
      @home_team_abbr = @xml_doc.root.attributes["home_code"]
      @away_team_abbr = @xml_doc.root.attributes["away_code"]
      set_pitchers
    end

    private

    def set_pitchers
      @home_pitcher = FuturePitchers.new(@xml_doc.root.elements["home_probable_pitcher"])
      @away_pitcher = FuturePitchers.new(@xml_doc.root.elements["away_probable_pitcher"])
    end

    class FuturePitchers
      attr_accessor :first_name, :last_name, :pid, :number, :wins, :losses, :era

      def initialize(element)
        @pid = element.attributes['id']
        @first_name = element.attributes['first_name']
        @last_name = element.attributes['last_name']
        @number = element.attributes['number']
        @wins = element.attributes['wins']
        @losses = element.attributes['losses']
        @era = element.attributes['era']
      end
    end

  end
end

