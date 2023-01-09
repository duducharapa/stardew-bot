require "discordcr"
require "sqlite3"
require "./mappings/item"

module StardewBot

  class Replier
    def searchItem(query : String) : Discord::Embed | Nil
      item = nil
      embed = nil
      sources = ""

      DB.open "sqlite3://data.db" do |db|
    
        db.query "SELECT i.name, i.link, i.image,s.name AS source FROM items AS i
        INNER JOIN items_sources AS itsc ON itsc.item_id = i.id
        INNER JOIN sources AS s ON itsc.source_id = s.id WHERE i.name LIKE (?)", query do |rs|
          
          item = StardewBot::Item.new "", "", "", [] of String
          counter = 0

          rs.each do
            item.name = rs.read(String)
            item.link = rs.read(String)
            item.image = rs.read(String)
            item.sources << rs.read(String)
          end

          item = nil if item.name.blank?

        end
    
      end

      unless item.nil?

        item.sources.each do |font|
          sources = "#{sources}> #{font}\n"
        end

        embed = Discord::Embed.new(
          title: item.name,
          image: Discord::EmbedImage.new(url: item.image),
          fields: [
            Discord::EmbedField.new(
              name: "Fontes:",
              value: sources
            ),
            Discord::EmbedField.new(
              name: "Mais detalhes:",
              value: item.link
            )
          ]
        )
      end

      embed
    end
  end

end