require 'bitfield'
describe BitField do
  it "should count total set correctly" do
    field = BitField.new(32)
    field[1] = 1
    field[5] = 1
    field.total_set.should == 2
  end

  it "should intersect fields correctly" do
    left = BitField.new(32)
    left[1] = 1
    left[14] = 1

    right = BitField.new(32)
    right[14] = 1
    right[15] = 1

    intersection = left & right
    intersection[14].should == 1
    intersection.total_set.should == 1
  end
end
