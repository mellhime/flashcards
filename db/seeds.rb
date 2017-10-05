CardParser.perform.each do |pair|
  Card.create(original_text: pair[0], translated_text: pair[1], review_date: Date.today, pack_id: 1, user_id: 1)
end
