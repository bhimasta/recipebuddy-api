# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Facebook API library' do
  describe 'Page information' do
    it 'HAPPY: should provide correct page attributes' do
      page = RecipeBuddy::FacebookApi.new(FB_TOKEN)
                                     .page(PAGE_NAME)
      _(page.id).must_equal CORRECT['id']
      _(page.name).must_equal CORRECT['name']
    end

    it 'SAD: should raise exception on incorrect page' do
      proc do
        RecipeBuddy::FacebookApi.new(FB_TOKEN)
                                .page(BAD_PAGE_NAME)
      end.must_raise RecipeBuddy::Errors::NotFound
    end

    # it 'SAD: should raise exception when unauthorized' do
    #   proc do
    #     puts RecipeBuddy::FacebookApi.new(BAD_FB_TOKEN, cache: RESPONSE)
    #                             .page(PAGE_NAME)
    #   end.must_raise RecipeBuddy::FacebookApi::Errors::Unauthorized
    # end
  end

  describe 'Recipe information' do
    before do
      @page = RecipeBuddy::FacebookApi.new(FB_TOKEN)
                                      .page(PAGE_NAME)
    end

    it 'HAPPY: should recognize the from page' do
      recipe = @page.recipes[0]
      _(recipe.from).must_be_kind_of RecipeBuddy::Page
    end

    it 'HAPPY: should identify owner' do
      recipe = @page.recipes[0]
      _(recipe.from.id).wont_be_nil
      _(recipe.from.name).must_equal CORRECT['name']
    end

    it 'HAPPY: should check recipes' do
      recipes = @page.recipes
      _(recipes.count).must_equal CORRECT['posts'].count

      ids = recipes.map(&:id)
      correct_ids = CORRECT['posts'].map { |c| c['id'] }
      _(ids).must_equal correct_ids
    end
  end
end