require 'rails_helper'

feature "Angular works" do
  include SignUpAndLogin

  scenario "goofy model updaters are good to go" do
    sign_up_and_log_in
    visit "/angular_test"
    screenshot! filename: "angular_test-before.png"
    fill_in "name", with: "Bob"
    within "header h1" do
      expect(page).to have_content "Bob"
    end
    screenshot! filename: "angular_test-after.png"
  end
end
