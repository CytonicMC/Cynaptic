class ExternalRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :external, reading: :external }
end
