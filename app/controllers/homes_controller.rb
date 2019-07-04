class HomesController < ApplicationController
	 
	def index
		@purchases = spaceship_app.in_app_purchases.all
	end
	
	def new
		spaceship_pricing = Spaceship::TunesClient.new 
		@tiers = spaceship_pricing.pricing_tiers.collect{|p| [p.tier_stem,p.tier_name]}
	end 
	
	def create
		result = spaceship_app.in_app_purchases.create!(
    	type: Spaceship::Tunes::IAPType::CONSUMABLE, 
    	versions: {
      	"en-US" => {
        	name: params['name'],
        	description: params['description']
      	}
    	},
    	reference_name: params['reference_name'],
    	product_id: params['product_id'],
    	cleared_for_sale: true,
    	pricing_intervals: [{
        country: "WW",
        begin_date: nil,
        end_date: nil,
        tier: params['price']
      }] 
  	)
  	if result["statusCode"] == "SUCCESS"
  		redirect_to home_path(params['product_id'])
  	end  
	end

	def show
		@product = spaceship_app.in_app_purchases.find(params['id']) 
	end 

	private 
	def spaceship_app
		Spaceship::Tunes.login("test4@appmanager.io","w-dekmC*c*Y8*L6.TKBo")
		Spaceship::Tunes::Application.find("io.transporterapp.test1")
	end  
end
