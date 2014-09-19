module Redmine
  module Acts
    module Journalized

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_journalized(options = {})
          cattr_accessor :journalized_options

          options.assert_valid_keys(:excepted_attributes, :relation_name, :relation_options)
          self.journalized_options = {
              excepted_attributes: [:updated_at, :updated_on],
              relation_name: 'journals',
              relation_options: {}
          }.merge(options)

          relation_options = {class_name: 'Journal', as: :journalized, dependent: :destroy}.
              merge(self.journalized_options[:relation_options])

          has_many self.journalized_options[:relation_name].to_sym, relation_options

          send :include, Redmine::Acts::Journalized::InstanceMethods

          before_update :journalize_attributes
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def init_journal(user = User.current, notes = '')
          @journal ||= send(self.journalized_options[:relation_name]).build(user: user, notes: notes)
        end

        def excepted_attributes
          self.class.journalized_options[:excepted_attributes]
        end

        def journalize_attributes(user = User.current, notes = '')
          init_journal(user, notes)
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