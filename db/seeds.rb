user = User.find_by(email: "test@mail.ru") || User.create(name: "Test", email: "test@mail.ru", password: "testpassword", password_confirmation: "testpassword")
pack = Pack.find_by(name: "Testpack") || Pack.create(name: "Testpack", user_id: user.id)

CardParser.perform.each do |pair|
  Card.create(original_text: pair[0], translated_text: pair[1], review_date: Date.today, pack_id: pack.id, user_id: user.id)
end
