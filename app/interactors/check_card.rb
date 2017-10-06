class CheckCard
  include Interactor

  def call
    if context.user_text == context.card.original_text
      context.card.check_count += 3 unless context.card.check_count == 16
      context.card.save
      context.message = "Правильно!"
    else
      context.card.check_count -= 1 unless context.card.check_count.zero?
      context.card.save
      context.fail!(message: "Неправильно!")
    end
  end
end
