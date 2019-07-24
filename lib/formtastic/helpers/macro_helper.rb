module Formtastic
  module Helpers
    module MacroHelper
      # Workaround for Mongoid 7.0 macro method removal.
      def macro_for(reflection)
        if reflection.respond_to?(:macro)
          reflection.macro
        else
          reflection.class.name.demodulize.underscore.to_sym
        end
      end
    end
  end
end
