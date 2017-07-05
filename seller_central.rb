class SellerCentral

	require 'csv'

	attr_accessor :income, :fees, :total, :date

	def initialize
		@income = Hash.new{ |h, k| h[k] = {qty: 0, principle: 0, returns: 0} }
		@fees = Hash.new(0)
		@total = 0
		@date = Date.new
	end

	def get_total(file_name)
		data = CSV.read(file_name, headers: true, converters: :numeric)
		@total = data[0]['total-amount']
	end

	def get_date(file_name)
		data = CSV.read(file_name, headers: true, converters: :date)
		@date = data[0]['settlement-end-date'].scan(/\d{4}-\d{2}-\d{2}/).first
	end

	def get_principle(file_name)
		CSV.foreach(file_name, headers: true, converters: :numeric) do |row|
			if row["amount-description"] == "Principal"
				sku = row["sku"].to_s
				if !row["quantity-purchased"].nil?
					@income[sku][:qty] += row["quantity-purchased"]
					@income[sku][:principle] += row["amount"]
				else
					@income[sku][:returns] += row["amount"]
				end
			end
		end
	end

	def total_revenue
		revenue = 0
		@income.each do |key, value|
			revenue += value[:principle] + value[:returns]
		end
		revenue
	end

	def get_fees(file_name)
		CSV.foreach(file_name, headers: true, converters: :numeric) do |row|
			if row["amount-description"] != "Principal" && !row["amount-description"].nil?
				@fees[row["amount-description"]] += row["amount"]
			end
		end
	end

	def total_fees
		debits = 0
		@fees.each do |type, charge| 
			debits += charge
		end
		debits
	end

	def total_calc
		(total_revenue + total_fees).round(2)
	end

	def create_output
		filename = "#{@date}_sales_report.csv"
		CSV.open(filename, 'w') do |csv|
			# get the relevant summary information in
			display_date = Date.parse(@date).strftime('%-m/%d/%Y')
			display_price = '%.2f' % @total
			csv << ["","Amazon Seller Central Total for #{display_date}, totals $#{display_price}"]
			#create the headers
			csv << ['Item Number', 'Units Sold', 'Unit Price', 'Return Value', 'Total']
			#populate the sales information
			@income.each do |item, data|
				sku = item
				quantity = data[:qty]
				revenue = data[:principle]
				returns = data[:returns]
				if revenue != 0
					csv << [sku, quantity, (revenue/quantity).round(5), returns, revenue.round(2)]
				else
					csv << [sku, quantity, 0, returns, revenue.round(2)]
				end
			end
			#populate the fees
			csv << ['Fee', 'Fee Total']
			@fees.each do |fee, total|
				csv <<[fee, total.round(2)]
			end
		end
	end

	def run_file(fileName)
		self.get_total(fileName)
		self.get_date(fileName)
		self.get_principle(fileName)
		self.get_fees(fileName)
		self.total_revenue
		self.total_fees
		self.total_calc
		self.create_output
	end
end

