module Formtastic
  module Helpers
    # @private
    module Reflection
      # If an association method is passed in (f.input :author) try to find the
      # reflection object.
      def reflection_for(method) # @private
        if @object.class.respond_to?(:reflect_on_association)
          Formtastic::Reflection.new @object.class.reflect_on_association(method)
        elsif @object.class.respond_to?(:associations) # MongoMapper uses the 'associations(method)' instead
          Formtastic::Reflection.new @object.class.associations[method]
        end
      end

      def association_macro_for_method(method) # @private
        reflection = reflection_for(method)
        reflection.macro
      end

      def association_primary_key_for_method(method) # @private
        reflection = reflection_for(method)
        reflection ? reflection.primary_key : method.to_sym
      end
    end
  end
end