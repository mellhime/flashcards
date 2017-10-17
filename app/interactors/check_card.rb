class CheckCard
  include Interactor

  SCORE = { 1..15 => 5, 16..60 => 4, 61..Float::INFINITY => 3 }.freeze

  def call
    if context.user_text == context.card.original_text
      score = SCORE.select { |k, _v| k.include?(context.seconds.to_i) }.values.first
      context.card.review_status += 1
      context.card.easiness_factor += (0.1 - (5 - score) * (0.08 + (5 - score) * 0.02))
      context.message = I18n.t('cards.check.success')
    else
      distance = DamerauLevenshtein.distance(context.user_text, context.card.original_text)
      return context.fail!(message: I18n.t('interactors.misprint')) if distance <= 2

      context.card.review_status = 1
      context.fail!(message: I18n.t('cards.check.danger'))
    end

    context.card.interval = if context.card.review_status == 1
                              1
                            elsif context.card.review_status == 2
                              6
                            else
                              context.card.interval * context.card.easiness_factor
                            end

    context.card.review_date = Time.current + context.card.interval.days
    context.card.save
  end
end
