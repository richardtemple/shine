require 'rails_helper'

describe CustomersController do
  describe "#index" do
    before do
      sign_in create(:user)
      @first_name_match  = create(:customer, first_name: "JJones")
      @last_name_match   = create(:customer, last_name: "JJones")
      @email_match       = create(:customer, email: "jjones1234@whatever.com")
      5.times { create(:customer) }
    end
    context "html" do
      before do
        get :index, keywords: keywords
      end
      context "no search criteria" do
        let(:keywords) { nil }
        specify { expect(response.code).to eq("200") }
        specify { expect(assigns(:customers)).to eq([]) }
      end
      context "search criteria" do
        context "search by email" do
          let(:keywords) { "jjones1234@whatever.com" }
          specify { expect(response.code).to eq("200") }
          it "returns the matching results by first name, last name, or email" do
            expect(assigns(:customers)).to include(@first_name_match)
            expect(assigns(:customers)).to include(@last_name_match)
            expect(assigns(:customers)).to include(@email_match)
            expect(assigns(:customers).first).to eq(@email_match)
            expect(assigns(:customers).size).to eq(3)
          end
        end
        context "search by name" do
          let(:keywords) { "jjones" }
          specify { expect(response.code).to eq("200") }
          it "returns the matching results by first name, last name, or email" do
            expect(assigns(:customers)).to include(@first_name_match)
            expect(assigns(:customers)).to include(@last_name_match)
            expect(assigns(:customers).size).to eq(2)
          end
        end
      end
    end

    context "json" do
      before do
        get :index, keywords: keywords, format: :json
        @parsed_customers = JSON.parse(response.body)
      end
      context "no search criteria" do
        let(:keywords) { nil }
        specify { expect(response.code).to eq("200") }
        specify { expect(@parsed_customers).to eq([]) }
      end
      context "search criteria" do
        context "search by email" do
          let(:keywords) { "jjones1234@whatever.com" }
          specify { expect(response.code).to eq("200") }
          it "returns the matching results by first name, last name, or email" do
            expect(@parsed_customers.map { |_| _["id"] }).to include(@first_name_match.id)
            expect(@parsed_customers.map { |_| _["id"] }).to include(@last_name_match.id)
            expect(@parsed_customers.map { |_| _["id"] }).to include(@email_match.id)

            expect(@parsed_customers.first["id"]).to eq(@email_match.id)
            expect(@parsed_customers.size).to eq(3)
          end
        end
        context "search by name" do
          let(:keywords) { "jjones" }
          specify { expect(response.code).to eq("200") }
          it "returns the matching results by first name, last name, or email" do
            expect(@parsed_customers.map { |_| _["id"] }).to include(@first_name_match.id)
            expect(@parsed_customers.map { |_| _["id"] }).to include(@last_name_match.id)

            expect(@parsed_customers.size).to eq(2)
          end
        end
      end
    end
  end
end
