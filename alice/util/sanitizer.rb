module Alice

  module Util
    
    class Sanitizer

      def self.process(text)
        text.gsub!("the the", "the")
        text.gsub!("the ye", "ye")
        text.gsub!("a the", "a")
        text.gsub!("a ye", "ye")
        text.gsub!("a a", "an a")
        text.gsub!("a e", "an e")
        text.gsub!("a i", "an i")
        text.gsub!("a o", "an o")
        text.gsub!(/^am/i, 'is')
        text.gsub!('..', '.')
        text.gsub!('  ', ' ')
        text
      end

      def self.strip_pronouns(text)
        text.gsub!(/^I /i, '')
      end

    end

  end

end