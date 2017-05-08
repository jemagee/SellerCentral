class SellerCentral

	require 'csv'

	attr_accessor :income, :fees, :total

	def initialize
		@income = Hash.new{ |h, k| h[k] = {qty: 0, principle: 0, returns: 0} }
		@fees = Hash.new(0)
		@total = 0
	end

	def get_total(file_name)
		data = CSV.read(file_name, headers: true, converters: :numeric)
		@total = data[0]['total-amount']
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
			revenue += @income[key][:principle] + @income[key][:returns]
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
			debits += @fees[type]
		end
		debits
	end
end

