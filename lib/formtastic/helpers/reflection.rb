module Formtastic
  module Helpers
    # @private
    module Reflection
      # If an association method is passed in (f.input :author) try to find the
      # reflection object.
      def reflection_for(method) # @private
        if @object.class.respond_to?(:reflect_on_association)
          @object.class.reflect_on_association(method)
        elsif @object.class.respond_to?(:associations) # MongoMapper uses the 'associations(method)' instead
          @object.class.associations[method]
        end
      end

      def association_macro_for_method(method) # @private
        reflection = reflection_for(method)

        return unless reflection

        if reflection.respond_to?(:macro)
          reflection.macro
        else
          reflection.class.name.demodulize.underscore.to_sym
        end
      end

      def association_primary_key_for_method(method) # @private
        reflection = reflection_for(method)
        if reflection
          case association_macro_for_method(method)
          when :has_and_belongs_to_many, :has_many, :references_and_referenced_in_many, :references_many
            :"#{method.to_s.singularize}_ids"
          else
            return reflection.foreign_key.to_sym if reflection.respond_to?(:foreign_key)
            return reflection.options[:foreign_key].to_sym unless reflection.options[:foreign_key].blank?
            :"#{method}_id"
          end
        else
          method.to_sym
        end
      end
    end
  end
end