# frozen_string_literal: true

require 'dry/transaction'

module RecipeBuddy
  # Service to find a page from database
  # Usage:
  #   result = FindDatabasePage.call(pagename: 'RecipesAndCookingGuide')
  #   result.success?
  module ListPage
    extend Dry::Monads::Either::Mixin

    def self.id_call(input)
      page = Repository::For[Entity::Page]
             .pagenamebyid(input[:id])
      if page
        Right(Result.new(:ok, page))
      else
        Left(Result.new(:not_found, 'Could not find stored page'))
      end
    end
  end
end
