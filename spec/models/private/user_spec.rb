require 'rails_helper'

describe User do
  describe "email" do
    it "does not allow non-company email addresses" do
      user = User.create(email: "foo@bar.com")
      expect(user.valid?).to eq(false)
    end

    it "does allows company email addresses" do
      user = User.create(email: "foo@example.com", password: "qwertyuiop", password_confirmation: "qwertyuiop")
      expect(user.valid?).to eq(true)
      user.save!
    end

    it "does not allow existing users to circumvent the email address policy" do
      user = User.create(email: "foo@example.com", password: "qwertyuiop", password_confirmation: "qwertyuiop")
      user.save!
      expect {
        user.update_attribute(:email, "foo@bar.com")
      }.to raise_error(/new row for relation .users. violates check constraint/)
    end
  end
end
