class CheckCard
  include Interactor

  def call
    if context.user_text == context.card.original_text
      context.card.review_status += 1 # переименовала check_count на review_status
      context.card.easiness_factor += (0.1 - (5 - context.score.to_i) * (0.08 + (5 - context.score.to_i) * 0.02))
      context.message = I18n.t('cards.check.success')  
    else # в случае неправильного ответа нам вообще не нужна оценка качества ответа (score), т.к. если качество ответа меньше 3: интервал проверки возвращается к самому началу
      distance = DamerauLevenshtein.distance(context.user_text, context.card.original_text)
      return context.fail!(message: I18n.t('interactors.misprint')) if distance <= 2

      context.card.review_status = 1
      context.fail!(message: I18n.t('cards.check.danger'))
    end

    context.card.interval = if context.card.review_status == 1
                              1
                            elsif context.card.review_status == 2
                              6
                            else # если карточка показывается больше чем 2-ой раз, её интервал показа вычисляется путем умножения предыдущего интервала на EF
                              context.card.interval * context.card.easiness_factor
                            end
                            
    context.card.review_date = Time.current + context.card.interval.days # обновляем дату проверки с учетом вычисленного интервала
    context.card.save
  end
end
