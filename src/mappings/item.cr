module StardewBot
  
  struct Item
    property name : String
    property image : String
    property link : String
    property sources = [] of String
  
    def initialize(@name : String, @link : String, @image : String, @sources : Array(String))
    end
  end

end