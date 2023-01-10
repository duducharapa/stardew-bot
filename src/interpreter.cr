require "discordcr"

require "./seeker"

module StardewBot
  class Interpreter

    private property discord_client

    WHITESPACE = " "
    PREFIX = "!"

    SEEKER = StardewBot::Seeker.new

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
        item = SEEKER.find_item(search.downcase)

        unless item.nil?
          embed_message = mount_embed_message(item)
          reply(embed_message, channel_id)
        else
          error_message = "Item **#{search}** não encontrado!"
          reply(error_message, channel_id)
        end
      end
    end

    def mount_embed_message(item : StardewBot::Item) : Discord::Embed
      sources = translate_sources(item.sources)

      embed = Discord::Embed.new(
        title: item.name,
        image: Discord::EmbedImage.new(url: item.image),
        fields: [
          Discord::EmbedField.new(name: "Fontes", value: sources),
          Discord::EmbedField.new(name: "Wiki link", value: item.link)
        ]
      )

      embed
    end

    def translate_sources(sources : Array(String)) : String
      joined_sources = ""

      unless sources == [] of String
        sources.each do |source|
          joined_sources = joined_sources.insert(-1, "> #{source}\n")
        end
      else
        return "Fontes desconhecidas"
      end

      joined_sources
    end

  end
end
