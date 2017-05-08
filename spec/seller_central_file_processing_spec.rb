require 'spec_helper'

describe SellerCentral do

	before :each do
		@invoice = SellerCentral.new
	end

	describe '#new' do
		it "creates an instance variable" do
			expect(@invoice).to be_an_instance_of SellerCentral
		end

		it "creates and empty hash called income" do
			expect(@invoice.income).to be_an_instance_of Hash
		end

		it "should have an income hash that has a a qty key set to zero" do
			expect(@invoice.income["13445"][:qty] += 10 ).to eq 10
		end

		it "should have an income hash that has a principal key set to zero" do
			expect(@invoice.income["53524_NI"][:principle]).to eq 0
		end

		it "should have an instance variable total set to 0" do
			expect(@invoice.total).to eq 0
		end
	end

	describe '#gettting the total' do
		it "should get the right total" do
			@invoice.get_total("spec/fixtures/sc_test_file.csv")
			expect(@invoice.total).to eq 4246.2
		end
	end

	context "Processing the principles do"  do
		before do
			@invoice.get_principle("spec/fixtures/sc_test_file.csv")
		end

		it "should get the right quantity" do
			expect(@invoice.income["43220"][:qty]).to eq 201
		end

		it "should get the right principle total" do
			expect(@invoice.income["80013_NI"][:principle].round(2)).to eq 1187.52
		end

		it "should get the right principle total with returns" do
			expect(@invoice.income["43081"][:principle].round(2)).to eq 179.88
			expect(@invoice.income["43081"][:returns].round(2)).to eq -14.99
		end

		it "should get the right total revenue" do
			expect(@invoice.total_revenue.round(2)).to eq 9619.3
		end
	end
end