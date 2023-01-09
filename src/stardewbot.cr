require "discordcr"
require "dotenv"

require "./mappings/item"
require "./replier"

Dotenv.load

client = Discord::Client.new(
  token = ENV["TOKEN"],
  client_id = ENV["CLIENT_ID"].to_u64
)

replier = StardewBot::Replier.new

client.on_message_create do |payload|
  if payload.content.starts_with? "!"
    command, search = payload.content.split(" ")[0][1..], payload.content.split(" ")[1]

    unless search.nil?
      case command
      when "find"
        embed = replier.searchItem search.downcase
        
        unless embed.nil?
          client.create_message(payload.channel_id, "", embed)
        else
          client.create_message(payload.channel_id, "Não foi encontrado um item com o nome #{search}")
        end
      end
    end
  end

end

client.run