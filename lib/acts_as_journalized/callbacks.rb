module Redmine
  module Acts
    module Journalized
      module Callbacks
        extend ActiveSupport::Concern

        def init_journal(user = User.current, notes = '')
          @journal ||= Journal.new(journalized: self, user: user, notes: notes)
        end

        def create_journal_on_create
          if @journal
            @journal.save
          end
        end

        def create_journal_on_update
          if @journal && @journal.changed?
            @journal.save
          else
            journalized_changes =
                changes.slice(
                    *self.class.journalized_attribute_names
                )
            if journalized_changes.present?
              init_journal
              journalized_changes.each_pair do |column, values|
                @journal.details.build(property: 'attr', prop_key: column, old_value: values.first, value: values.last)
              end
              @journal.save
            end
          end
        end
      end
    end
  end
end
