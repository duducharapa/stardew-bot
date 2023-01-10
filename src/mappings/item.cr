require "db"

module StardewBot

  class Item
    include DB::Serializable

    property id : Int32
    property name : String
    property image : String
    property link : String
    property sources = [] of String

    def initialize()
      @id = 0
      @name = ""
      @image = ""
      @link = ""
    end
  end

end
