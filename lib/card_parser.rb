require 'open-uri'
require 'nokogiri'

class CardParser

  def self.perform
    url = 'http://www.en365.ru/top100.htm'
    html = open(url)
    doc = Nokogiri::HTML(html, "UTF-8")
    original_texts = []
    translated_texts = []

    doc.css('tr').each do |tr|
      unless tr.css('td')[1].nil?
        original_texts << tr.css('td')[1].text 
        translated_texts << tr.css('td')[2].text
      end
    end

    original_texts = original_texts.slice(2..-1).map { |word| word.slice(0..(word.index(' ')))}
    translated_texts = translated_texts.slice(2..-1)
    new_arr = original_texts.zip(translated_texts)
    new_arr
  end
end
