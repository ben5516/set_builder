require 'set_builder/modifier/verb'


module SetBuilder
  module Modifiers
    class StringModifier < Modifier::Verb
      
      
      
      def self.operators
        {
          :contains => [:string],
          :does_not_contain => [:string],
          :begins_with => [:string],
          :does_not_begin_with => [:string],
          :ends_with => [:string],
          :does_not_end_with => [:string],
          :is => [:string],
          :is_not => [:string]
        }
      end
      
      
      
      def self.negate(operator)
        case operator
        when :contains
          "does not contain"
        when :begins_with
          "does not begin with"
        when :ends_with
          "does not end with"
        when :is
          "is not"
        end
      end
      
      
      
      def build_conditions_for(selector, operator=nil)
        operator ||= self.operator
        case operator
        
        when :does_not_contain
          negate(selector, :contains)
        when :does_not_begin_with
          negate(selector, :begins_with)
        when :does_not_end_with
          negate(selector, :ends_with)
        when :is_not
          negate(selector, :is)
        
        when :is
          ["#{selector}=?", values[0]]
        else
          ["#{selector} LIKE ?", get_like_value_for_operator]
        end
      end
      
      
      
      def build_arel_for(selector, operator=nil)
        operator ||= self.operator
        case operator
        when :is
          selector.eq(values[0])
        when :is_not
          selector.not_eq(values[0])
        when :contains, :begins_with, :ends_with
          selector.matches(get_like_value_for_operator)
        when :does_not_contain, :does_not_begin_with, :does_not_end_with
          selector.does_not_match(get_like_value_for_operator)
        end
      end
      
      
      
    private
      
      
      
      def get_like_value_for_operator
        case operator
        when :contains, :does_not_contain
          "%#{values[0]}%"
        when :begins_with, :does_not_begin_with
          "#{values[0]}%"
        when :ends_with, :does_not_end_with
          "%#{values[0]}"
        end
      end
      
      
      
    end
  end
end
