require 'rails_helper'

RSpec.describe Trip, type: :model do
  subject {build :trip}

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it {is_expected.to accept_nested_attributes_for(:place)}

  describe "#name" do
    context "is not valid without name" do
      subject {build :trip, name: nil}
      it {
        subject.valid?
        expect(subject.errors[:name].size).to eq(1)
      }
    end

    context "is not valid with name too long" do
      subject {build :trip, name: "cgfcgcfcgfccfgcgfccfcfgcfgfgcfcfcfcfcfcfcf
        vgvgvgvgvgvgvg"}
      it {
        subject.valid?
        expect(subject.errors[:name].size).to eq(1)
      }
    end
  end

  describe ".Associations" do
    it { expect(Trip.reflect_on_association(:participations).macro)
      .to eq(:has_many)}
    it { expect(Trip.reflect_on_association(:members).macro).to eq(:has_many)}
    it { expect(Trip.reflect_on_association(:place).macro).to eq(:belongs_to)}
    it { expect(Trip.reflect_on_association(:owner).macro)
      .to eq(:belongs_to)}
  end
end
