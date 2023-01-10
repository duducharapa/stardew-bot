require "discordcr"
require "dotenv"

require "./mappings/item"
require "./interpreter"

Dotenv.load

client = Discord::Client.new(
  token = ENV["TOKEN"],
  client_id = ENV["CLIENT_ID"].to_u64
)

client.on_message_create do |payload|
  interpreter = StardewBot::Interpreter.new(client)
  interpreter.interpret(payload.content, payload.channel_id)
end

client.run