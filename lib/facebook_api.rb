# frozen_string_literal: false

require 'http'
# require_relative 'entities/page.rb'
# require_relative 'entities/recipe.rb'
# require_relative 'entities/errors.rb'

module RecipeBuddy
  # Talk to Facebook
  module Facebook
    # Library for Facebook Web API
    class FacebookApi
      # Encapsulates API response success and errors
      module Errors
        # Not allowed to access resource
        Unauthorized = Class.new(StandardError)
        # Requested resource not found
        NotFound = Class.new(StandardError)
        # Bad request
        BadRequest = Class.new(StandardError)
      end
      # Encapsulates API response success and errors
      class Response
        HTTP_ERROR = {
          401 => Errors::Unauthorized,
          404 => Errors::NotFound
        }.freeze

        def initialize(response)
          @response = response
        end

        def successful?
          return false if HTTP_ERROR.keys.include?(@response.code)
          # return false unless @response['errors'].nil?
          true
        end

        def response_or_error
          successful? ? @response : raise(HTTP_ERROR[@response.code])
        end
      end

      def initialize(token)
        @fb_token = token
      end

      def page_data(name)
        page_req_url = FacebookApi.path(name)
        page_data = call_fb_url(page_req_url).parse
      end

      def recipe_data(path)
        recipes_url = FacebookApi.recipes_path(path)
        receipes_response_parsed = call_fb_url(recipes_url).parse
        recipes_data = receipes_response_parsed['data']
      end

      def self.recipes_path(path)
        'https://graph.facebook.com/v2.10/' + path
      end

      private

      def headers
        { 'Accept' => 'application/json',
          'Authorization' => "OAuth #{@fb_token}" }
      end

      def call_fb_url(url)
        response = HTTP.headers(headers)
                       .get(url)
        Response.new(response).response_or_error
      end
    end
  end
end
