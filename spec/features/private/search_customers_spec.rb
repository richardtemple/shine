require 'rails_helper'

feature "customers search" do
  include SignUpAndLogin

  scenario "see the search form and sample results" do
    sign_up_and_log_in
    2.times do |i|
      Customer.create!(
        first_name:    "Robert",
         last_name:    Faker::Name.last_name,
          username: "#{Faker::Internet.user_name}#{i}",
             email: "#{Faker::Internet.user_name}#{i}@#{Faker::Internet.domain_name}")
    end
    5.times do |i|
      Customer.create!(
        first_name: "Bob",
         last_name:    Faker::Name.last_name,
          username: "#{Faker::Internet.user_name}#{i}",
             email: "#{Faker::Internet.user_name}#{i}@#{Faker::Internet.domain_name}")
    end
    4.times do |i|
      Customer.create!(
        first_name:    Faker::Name.first_name,
         last_name: "Bob",
          username: "#{Faker::Internet.user_name}#{i}",
             email: "#{Faker::Internet.user_name}#{i}@#{Faker::Internet.domain_name}")
    end
    Customer.create!(
      first_name:    Faker::Name.first_name,
       last_name: "Bobby",
        username: "#{Faker::Internet.user_name}5",
           email: "#{Faker::Internet.user_name}5@#{Faker::Internet.domain_name}")
    Customer.create!(
      first_name: "Robert",
       last_name: "Jones",
        username: "bobby_#{Faker::Internet.user_name}",
           email: "bob123@somewhere.net")
    click_link "Customer Search"
    expect(page).to have_content("Customer Search")
    within "section.search-form" do
      expect(page).to have_selector("input[name='keywords']")
      fill_in "keywords", with: "bob123@somewhere.net"
      click_button "Find Customers"
    end
    within "section.search-results" do
      expect(page).to have_content("Results")
      expect(page.all("ol li.list-group-item").count).to eq(10)
      expect(page).to have_selector("nav .pager")
      first("nav .pager li.next a").click
      screenshot! filename: "customer-search-component.png", selector: "ol li.list-group-item:nth-of-type(1)"
    end
    screenshot! filename: "customer-search.png"
  end
end
