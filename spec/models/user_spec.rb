require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context "with corret name and email" do
    it "is valid" do
      user.save
      expect(user).to be_valid
      valid_addresses = %w(
        user@example.com USER@foo.COM A_US-ER@foo.bar.org
        first.last@foo.jp alice+bob@baz.cn
      )
      valid_addresses.each do |valid_address|
        user.email = valid_address
        user.save
        expect(user).to be_valid
      end
    end

    it "saved email address as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user.email = mixed_case_email
      user.save
      expect(user.email).to eq mixed_case_email.downcase
    end

    it "authenticated? should return false for a user with nil digest" do
      user.authenticated?(:remember, "")
      expect(user).to be_truthy
    end
  end

  context "without name" do
    it "is not be valid" do
      user.name = nil
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  context "with too long name" do
    it "is not be valid" do
      user.name = "a" * 51
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end
  end

  context "without email" do
    it "is not be valid" do
      user.email = nil
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  context "with too long email" do
    it "is not be valid" do
      user.email = "a" * 244 + "@example.com"
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end
  end

  context "with invalid email addresses" do
    it "is not be valid" do
      invalid_addresses = %w(
        user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com
      )
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to be_invalid
      end
    end
  end

  context "with duplicated email addresses" do
    let(:duplicate_user) { build(:user, email: user.email) }

    it "is not be valid" do
      user.save
      expect(user).to be_valid
      expect(duplicate_user).to be_invalid
    end
  end

  context "with wrong password" do
    it "is not be valid" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
      user.password = user.password_confirmation = "a" * 5
      expect(user).to be_invalid
    end
  end
end
