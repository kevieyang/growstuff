require 'rails_helper'

describe "crops/search" do
  before(:each) do
    controller.stub(:current_user) { nil }
  end

  context "has results" do

    before :each do
      @tomato = FactoryGirl.create(:tomato)
      @roma = FactoryGirl.create(:crop, :name => 'Roma tomato', :parent => @tomato)
      assign(:search, 'tomato')
      assign(:exact_match, @tomato)
      assign(:partial_matches, [@roma])
      render
    end

    it "shows exact matches" do
      assert_select "div#exact_match" do
        assert_select "a[href=#{crop_path(@tomato)}]"
      end
    end

    it "shows partial matches" do
      assert_select "div#partial_matches" do
        assert_select "a[href=#{crop_path(@roma)}]"
      end
    end
  end

  context "no results" do
    before :each do
      assign(:exact_match, nil)
      assign(:partial_matches, [])
      assign(:search, 'tomato')
      render
    end

    it "tells you there are no matches" do
      rendered.should have_content "No results found"
    end

    it "links to browse crops" do
      assert_select "a", :href => crops_path
      rendered.should have_content "Try browsing our crop database instead"
    end
  end

end
