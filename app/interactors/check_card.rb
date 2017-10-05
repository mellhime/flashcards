class CheckCard
  include Interactor

  def call
    if context.user_text == context.card.original_text
      context.card.check_count += 1 unless context.card.check_count == 5
      context.card.fails_count = 0
      context.message = "Правильно!"
    else
      if context.card.fails_count < 3
        context.card.fails_count += 1
      else
        context.card.fails_count = 0
        context.card.check_count -= 1 unless context.card.check_count == 0
      end

      context.card.save
      context.fail!(message: "Неправильно!")
    end
  end
end
