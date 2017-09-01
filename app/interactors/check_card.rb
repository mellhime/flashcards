class CheckCard
  include Interactor

  def call
    if context.user_text == context.card.original_text
      context.card.update_attributes(review_date: Date.today + 3.days)
      context.message = "Правильно!"
    else
      context.fail!(message: "Неправильно!")
    end
  end
end
