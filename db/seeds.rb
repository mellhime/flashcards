require './lib/card_parser.rb'

CardParser.perform.each do |pair|
  Card.create(original_text: pair[0], translated_text: pair[1])
end
