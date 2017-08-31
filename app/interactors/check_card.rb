class CheckCard
  include Interactor

  def call
    if context.user_text == context.card.original_text
      context.card.update_attributes(review_date: Time.now + 259200)
    else
      context.fail!(message: "Неправильно!")
    end
  end
end
