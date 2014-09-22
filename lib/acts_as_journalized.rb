require 'acts_as_journalized/version'
require 'acts_as_journalized/callbacks'
require 'acts_as_journalized/acts_as_journalized'

ActiveRecord::Base.send(:include, Redmine::Acts::Journalized)
