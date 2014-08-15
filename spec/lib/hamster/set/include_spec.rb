require "spec_helper"
require "hamster/set"
require 'set'

describe Hamster::Set do
  [:include?, :member?, :contains?, :elem?].each do |method|
    describe "##{method}" do
      let(:set) { Hamster.set("A", "B", "C", 2.0, nil) }

      ["A", "B", "C", 2.0, nil].each do |value|
        it "returns true for an existing value (#{value.inspect})" do
          set.send(method, value).should == true
        end
      end

      it "returns false for a non-existing value" do
        set.send(method, "D").should == false
      end

      it "returns true even if existing value is nil" do
        Hamster.set(nil).include?(nil).should == true
      end

      it "returns true even if existing value is false" do
        Hamster.set(false).include?(false).should == true
      end

      it "returns false for a mutable item which is mutated after adding" do
        item = ['mutable']
        set  = Hamster::Set[item]
        item.push('HOSED!')
        set.should_not include(item)
      end

      it "uses #eql? for equality" do
        set.send(method, 2).should == false
      end

      it "returns the right answers after a lot of addings and removings" do
        array, set, rb_set = [], Hamster::Set.new, Set.new

        1000.times do
          if rand(1) == 0
            array << (item = rand(10000))
            rb_set.add(item)
            set = set.add(item)
            set.should include(item)
          else
            item = array.sample
            rb_set.delete(item)
            set = set.delete(item)
            set.should_not include(item)
          end
        end

        array.each { |item| set.include?(item).should == rb_set.include?(item) }
      end
    end
  end
end