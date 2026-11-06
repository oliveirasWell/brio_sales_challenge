# frozen_string_literal: true

module SalesTaxes
  module Item::Category
    EXEMPT = :exempt
    GENERAL = :general
    EVIL = :evil

    KEYWORDS = {
        'book' => EXEMPT,
        'chocolate' => EXEMPT,
        'pill' => EXEMPT,
        'cigarette' => EVIL,   
        'whiskey' => EVIL,   
    }

    module_function

    def for(name:)
        KEYWORDS.find do |keyword, category|
            name = name.downcase
            name = name.chomp('s') if name.end_with?('s')

            return category if name.include?(keyword)
        end
    
        GENERAL
    end 
  end
end
