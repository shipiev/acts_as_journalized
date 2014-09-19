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

          after_update :journalize_attributes
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def init_journal(user = User.current, notes = '')
          journal = Journal.new(journalized: self, user: user, notes: notes)
          yield journal
          journal.save
        end

        def excepted_attributes
          self.class.journalized_attributes[:excepted_attributes]
        end

        def journalize_attributes(user = User.current, notes = '')
          init_journal(user, notes) do |journal|
            changes.except(*excepted_attributes).each_pair do |column, values|
              journal.details.build(property: 'attr', prop_key: column, old_value: values.first, value: values.last)
            end
          end
        end

        private :journalize_attributes, :init_journal, :excepted_attributes

        module ClassMethods; end
      end

    end
  end
end