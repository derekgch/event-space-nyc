require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end


describe "Category" do

  it "has a name" do
    hot_dog = Category.create(
      name: "Unisex Adult Hot Dog Costume"
    )
    expect(Category.find_by(name: "Unisex Adult Hot Dog Costume")).to eq(hot_dog)
  end

end
