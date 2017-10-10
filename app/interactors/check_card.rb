class CheckCard
  include Interactor

  def call
    context.session[:fails_count] ||= 0
    if context.user_text == context.card.original_text
      context.card.check_count += 1 unless context.card.check_count == 5
      context.session[:fails_count] = nil
      context.card.save
      context.message = "Правильно!"
    else
      distance = DamerauLevenshtein.distance(context.user_text, context.card.original_text)
      return context.fail!(message: "Вы опечатались: #{context.user_text}. Слово: #{context.card.original_text} - #{context.card.translated_text}") if distance <= 2
      if context.session[:fails_count] < 3
        context.session[:card_id] = context.card.id
        context.session[:fails_count] += 1
      else
        context.session[:fails_count] = nil
        context.card.check_count -= 1 unless context.card.check_count.zero?
      end

      context.card.save
      context.fail!(message: "Неправильно!")
    end
  end
end
