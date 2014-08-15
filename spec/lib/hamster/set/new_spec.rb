require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe ".new" do
    it "initializes a new set" do
      set = Hamster::Set.new([1,2,3])
      set.size.should be(3)
      [1,2,3].each { |n| set.should include(n) }
    end

    it "accepts a Range" do
      set = Hamster::Set.new(1..3)
      set.size.should be(3)
      [1,2,3].each { |n| set.should include(n) }
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Set)
        instance = subclass.new(["some", "values"])
        instance.class.should be subclass
        instance.should be_frozen
      end
    end

    it "is amenable to overriding of #initialize" do
      class SnazzySet < Hamster::Set
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      set = SnazzySet.new
      set.size.should be(1)
      set.should include('SNAZZY!!!')
    end
  end

  describe "[]" do
    it "accepts any number of arguments and initializes a new set" do
      set = Hamster::Set[1,2,3,4]
      set.size.should be(4)
      [1,2,3,4].each { |n| set.should include(n) }
    end
  end
end