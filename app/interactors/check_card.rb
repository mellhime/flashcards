class CheckCard
  include Interactor

  def call
    context.session[:fails_count] ||= { "id" => 0, "fails" => 0 }
    if context.user_text == context.card.original_text
      context.card.check_count += 1 unless context.card.check_count == 5
      context.session[:fails_count] = nil
      context.card.save
      context.message = "Правильно!"
    else
      if context.session[:fails_count]["fails"] < 3
        context.session[:fails_count]["id"] = context.card.id
        context.session[:fails_count]["fails"] += 1
      else
        context.session[:fails_count] = nil
        context.card.check_count -= 1 unless context.card.check_count.zero?
      end

      context.card.save
      context.fail!(message: "Неправильно!")
    end

  end
end
