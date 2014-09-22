module Redmine
  module Acts
    module Journalized
      extend ActiveSupport::Concern

      module ClassMethods
        def acts_as_journalized(options = {})
          cattr_accessor :journalized_options

          options.assert_valid_keys(:excepted_attributes, :name, :find_options)
          self.journalized_options = {
              excepted_attributes: [:updated_at, :updated_on],
              name: 'journals',
              find_options: {}
          }.merge(options)

          find_options = {class_name: 'Journal', as: :journalized, dependent: :destroy}.
              merge(self.journalized_options[:find_options])

          has_many self.journalized_options[:name].to_sym, find_options

          send :include, Redmine::Acts::Journalized::Callbacks

          before_update :journalize_attributes
        end
      end

    end
  end
end