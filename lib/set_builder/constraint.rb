require 'set_builder/modifier'


module SetBuilder
  class Constraint
    
    
    #
    # Sample constraints:
    # 
    #     [:awesome],
    #     [:attended, "school"],
    #     [:died],
    #     [:name, {:is => "Jerome"}]]
    # 
    def initialize(trait, *args, &block)
      @trait, @block = trait, block
      @direct_object = args.shift if trait.requires_direct_object?
      @modifiers = trait.modifiers.collect {|modifier_type| modifier_type.new(args.shift)}
    end
    
    
    
    attr_reader :trait, :direct_object, :modifiers
    
    
    
    delegate :direct_object_required?,
             :direct_object_type,
             :to => :trait
    
    
    
    def valid?
      (!direct_object_required? or !direct_object.nil?) and modifiers.all?(&:valid?)
    end
    
    
    
    def to_s
      @description ||= begin
        description = trait.to_s
        description << " #{ValueMap.to_s(direct_object_type, direct_object)}" if direct_object_required?
        description << " #{modifiers.join(" ")}" unless modifiers.empty?
        description
      end
    end
    
    
    
    def perform(scope)
      _block, _self = @block, self
      scope.instance_eval do      # the idea is to compose scopes: to filter within the context of the current scope
        _block.call(_self)
      end
    end
    
    
    
  end
end