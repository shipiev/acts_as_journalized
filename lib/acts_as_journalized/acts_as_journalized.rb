module Redmine
  module Acts
    module Journalized
      extend ActiveSupport::Concern

      def journalized_attribute_names
        self.class.journalized_attribute_names
      end

      module ClassMethods
        def acts_as_journalized(options = {})
          cattr_accessor :journalized_options, :journalized_attribute_names

          options.assert_valid_keys(
              :excepted_attributes,
              :name,
              :scope,
              :find_options
          )

          excepted_attributes =
              options.delete(:excepted_attributes) || %w(id updated_at updated_on)

          self.journalized_attribute_names = column_names - excepted_attributes

          self.journalized_options =
              {
                  name: 'journals',
                  scope: -> { all },
                  find_options: {}
              }.merge(options)

          find_options =
              {
                  class_name: 'Journal',
                  as: :journalized,
                  dependent: :destroy
              }.merge(journalized_options[:find_options])

          send :include, Redmine::Acts::Journalized::Callbacks

          has_many journalized_options[:name].to_sym,
                   journalized_options[:scope],
                   find_options

          after_create :create_journal_on_create
          after_update :create_journal_on_update
        end
      end

    end
  end
end
