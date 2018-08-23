require 'rails_helper'

RSpec.describe User, type: :model do

  subject {build(:user)}
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  describe "#name" do
    context "is not valid without name" do
      subject {build(:user, name: nil)}
      it{
        subject.valid?
        is_expected.to have(1).errors
      }
    end

    context "is not valid with name too long" do
      subject {build(:user, name: "cgdfvcfsdghvcjsdbkbsvbfhvdfjvbdfjb
        vdfhbvdfhvbfhbvhfvbhfbvhfh")}
      it {
        subject.valid?
        expect(subject.errors[:name].size).to eq(1)
      }
    end
  end

  describe "#email" do
    context "is not valid without email" do
      subject {build(:user, email: nil)}
      it{
        subject.valid?
        expect(subject.errors[:email].size).to eq(2)
      }
    end

    context "is not valid with email wrong format" do
      subject {build(:user, email: "sakurano97")}
      it {
        subject.valid?
        expect(subject.errors[:email].size).to eq(1)
      }
    end

    context "is not valid with email not unique" do
      subject {build(:user)}
      before {@another_user = FactoryBot.create :user}
      it {
        subject.valid?
        expect(subject.errors[:email].size).to eq(1)
      }
    end
  end

  describe "#password" do
    context "is not valid without password" do
      subject {build(:user, password: nil)}
      it{
        subject.valid?
        expect(subject.errors[:password].size).to eq(1)
      }
    end

    context "is not valid with password too short" do
      subject {build(:user, password: "1234", password_confirmation: "1234")}
      it {
        subject.valid?
        expect(subject.errors[:password].size).to eq(1)
      }
    end

    context "is not valid with password not match confirm" do
      subject {build(:user, password_confirmation: "12345678")}
      it {
        subject.valid?
        expect(subject.errors[:password_confirmation].size).to eq(1)
      }
    end
  end

  describe ".Associations" do
    it { expect(User.reflect_on_association(:chatrooms).macro).to eq(:has_many)}
    it { expect(User.reflect_on_association(:comments).macro).to eq(:has_many)}
    it { expect(User.reflect_on_association(:messages).macro).to eq(:has_many)}
    it { expect(User.reflect_on_association(:participations).macro)
      .to eq(:has_many)}
    it { expect(User.reflect_on_association(:trips).macro).to eq(:has_many)}
    it { expect(User.reflect_on_association(:reviews).macro).to eq(:has_many)}
    it { expect(User.reflect_on_association(:create_trips).macro)
      .to eq(:has_many)}
  end

  describe "#is_user?" do
    context "when no user" do
      it "not have user" do
        expect{subject.is_user?}.to raise_error(ArgumentError)
      end
    end

    context "when true" do
      it {expect(subject.is_user?(subject)).to be true}
    end

    context "when false" do
      let(:user1) {create(:user, email: "sakurano96@gmail.com")}
      it {expect(subject.is_user?(user1)).to be false}
    end
  end
end
