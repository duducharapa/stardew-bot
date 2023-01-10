require "sqlite3"

require "./mappings/item"

module StardewBot
  class Seeker

    SQLITE_PATH = "sqlite3://data.db"

    def find_item(name : String) : StardewBot::Item | Nil
      item, embed = nil, nil

      DB.open(SQLITE_PATH) do |db|
        item_query = "SELECT id, name, image, link FROM items WHERE name LIKE ? LIMIT 1"

        db.query(item_query, name) do |rs|
          items = StardewBot::Item.from_rs(rs)

          item = items[0] unless items == [] of StardewBot::Item
        end
      end

      item.sources = find_related_sources(item.id) unless item.nil?

      item
    end

    def find_related_sources(item_id : Int32) : Array(String)
      sources = [] of String

      DB.open(SQLITE_PATH) do |db|
        sources_query = "SELECT s.name FROM sources AS s
        INNER JOIN items_sources AS itsc ON itsc.source_id = s.id
        INNER JOIN items AS i ON itsc.item_id = i.id
        WHERE i.id = ?"

        db.query(sources_query, item_id) do |rs|
          rs.each do
            sources.push(rs.read(String))
          end
        end
      end

      sources
    end

  end
end
