module Redmine
  module Acts
    module Journalized
      module Callbacks
        extend ActiveSupport::Concern

        def init_journal(user = User.current, notes = '')
          @journal ||= send(self.journalized_options[:name]).build(user: user, notes: notes)
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
