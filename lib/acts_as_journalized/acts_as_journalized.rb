module Redmine
  module Acts
    module Journalized

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_activity_provider(options = {})
          cattr_accessor :journalized_options

          options.assert_valid_keys(:excepted_attributes)
          self.journalized_options = {excepted_attributes: [:updated_at, :updated_on] }
          self.journalized_options.merge(options)

          has_many :journals, as: :journalized, dependent: :destroy

          send :include, Redmine::Acts::Journalized::InstanceMethods

          before_update :journalize_attributes
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def excepted_attributes
          self.class.journalized_attributes[:excepted_attributes]
        end

        def journalize_attributes(user = User.current, notes = '')
          @journal ||= journals.build(user: user, notes: notes)
          changes.except(*excepted_attributes).each_pair do |column, values|
            @journal.details.build(property: 'attr', prop_key: column, old_value: values.first, value: values.last)
          end
        end

        private :journalize_attributes, :excepted_attributes

        module ClassMethods; end
      end

    end
  end
end