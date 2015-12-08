class AnalysisController < ApplicationController
	
	def index
		puts("========================this")
		
	end

	def day_view
		retailer = Retailer.new
		retailers = Retailer.all
		chart_type = "Daily View"
		chart_xAxisName = "Day"
		chart_yAxisName = "User Amount"

		days = []
		for retailer in retailers
			day = retailer.created_at.strftime("%d")
			days << day
		end


		count_hash = Hash.new(0)

		days.each do |day|
			count_hash[day] += 1
		end 
		
		chart_day = []
		chart_val = []

		count_hash.each do |k, v|
			chart_day << k
			chart_val << v
		end

		draw_chart(chart_type,chart_xAxisName, chart_yAxisName, chart_day, chart_val, )
		
	end

	def week_view
		retailer = Retailer.new
		retailers = Retailer.all
		chart_type = "Weekly View"
		chart_xAxisName = "Week"
		chart_yAxisName = "User Amount"

		weeks = []

		for retailer in retailers
			week = retailer.created_at.strftime("%U")
			weeks << week
		end

		count_hash = Hash.new(0)

		weeks.each do |week|
			count_hash[week] += 1
		end 
		
		chart_week = []
		chart_val = []

		count_hash.each do |k, v|
			chart_week << k
			chart_val << v
		end

		draw_chart(chart_type, chart_xAxisName, chart_yAxisName, chart_week, chart_val)

	end

	def month_view
		retailer = Retailer.new
		retailers = Retailer.all
		chart_type = "Monthly View"
		chart_xAxisName = "Month"
		chart_yAxisName = "User Amount"

		months = []

		for retailer in retailers
			month = retailer.created_at.strftime("%m")
			months << month
		end

		count_hash = Hash.new(0)

		months.each do |month|
			count_hash[month] += 1
		end 
		
		chart_month = []
		chart_val = []

		count_hash.each do |k, v|
			chart_month << k
			chart_val << v
		end

		draw_chart(chart_type, chart_xAxisName, chart_yAxisName, chart_month, chart_val)
	end

	private
	def draw_chart(chart_type, chart_xAxisName, chart_yAxisName, categories, datum)
		dates = []
		categories.each do |v|
			dates << {label: v}
		end

		counts = []
		datum.each do |v|
			counts << {value: v}
		end

		@chart = Fusioncharts::Chart.new({
        width: "600",
        height: "400",
        type: "mscolumn2d",
        renderAt: "chartContainer",
        dataSource: {
            chart: {
            caption: chart_type,
            subCaption: "草屋商家",
            xAxisname: chart_xAxisName,
            yAxisName: chart_yAxisName,
            numberPrefix: "",
            theme: "fint",
            exportEnabled: "1",
            },
            categories: [{
                    category: dates
                }],
                dataset: [
                    {
                        seriesname: "Sign Up Statistics",
                        data: counts
                    }
                    # ,
                    # {
                    #     seriesname: "Current Year",
                    #     data: [
                    #         { value: "25400" },
                    #         { value: "29800" },
                    #         { value: "21800" },
                    #         { value: "26800" }
                    #     ]
                    # }
              ]
        }
    })
 

	end

end
