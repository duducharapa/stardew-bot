require "discordcr"

require "./replier"

module StardewBot
  class Interpreter

    private property discord_client

    WHITESPACE = " "
    PREFIX = "!"
    
    REPLIER = StardewBot::Replier.new

    def initialize(@discord_client : Discord::Client)
    end

    def reply(message : Discord::Embed, channel_id : Discord::Snowflake)
      discord_client.create_message(channel_id, "", message)
    end

    def reply(message : String, channel_id : Discord::Snowflake)
      discord_client.create_message(channel_id, message)
    end

    def interpret(message : String, channel_id : Discord::Snowflake)
      has_prefix = message.starts_with? PREFIX

      args = message[1..].split(WHITESPACE)
      command, search = args[0], args[1..].join(WHITESPACE)

      if has_prefix && !search.blank?
        resolve_command(command, search, channel_id)
      end
    end

    def resolve_command(command : String, search : String, channel_id : Discord::Snowflake)
      case command
      when "find"
        embed_message = REPLIER.searchItem(search.downcase)

        unless embed_message.nil?
          reply(embed_message, channel_id)
        else
          error_message = "Item **#{search}** não encontrado!"
          reply(error_message, channel_id)
        end
      end
    end
  
  end
end