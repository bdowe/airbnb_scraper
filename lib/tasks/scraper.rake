namespace :scraper do
  desc "TODO"
  task scrape: :environment do
  	require 'nokogiri'
	require 'open-uri'
	require 'csv'


	class Array
	  def every(n)
	    select {|x| index(x) % n == 0}
	  end
	  def every_other
	    every 2
	  end
	end

	 
	# Store URL to be scraped
	url = "https://www.airbnb.com/s/Brooklyn--NY--United-States"
	 
	# Parse the page with Nokogiri
	page = Nokogiri::HTML(open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}")) 


	# Scrape the max number of pages and store in max_page variable
	page_numbers = []
	page.css("ul.buttonList_11hau3k li.buttonContainer_1am0dt a.link_1ko8une").each do |line|
	  page_numbers << line.text
	end
	page_numbers = page_numbers.map(&:to_i)
	max_page = page_numbers.max

	# Initialize empty arrays
	name = []
	price = []
	type = []
	beds = []
	reviews = []
	image_url = []
	# Loop once for every page of search results
	max_page.times do |i|
	 
	  # Open search results page
	  url = "https://www.airbnb.com/s/Brooklyn--NY--United-States/?section_offset=#{i}"
	  page = Nokogiri::HTML(open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}")) 

	  # Store data in arrays

	  #Works with multiple pages - might be repeat listings
	  page.css('div.ellipsized_1iurgbx[data-reactid] span.text_5mbkop-o_O-size_small_1gg2mc-o_O-weight_bold_153t78d-o_O-inline_g86r3e[data-reactid] span[data-reactid]').each do |line|
	    name << line.text.strip
	  end
	  name -= %w{Price}
	  name.delete_if {|s| s.include? "$"}
	  
	  #Doesn't work
	  page.css('div.inline_g86r3e[data-reactid] span.text_5mbkop-o_O-size_small_1gg2mc-o_O-weight_bold_153t78d-o_O-inline_g86r3e').each do |line|
	    price << line.text.strip
	  end
	  price.delete_if(&:empty?)
	  price = price.map { |val|
	  	val.tr('Price$', '')
	  }
	  price.delete_if {|s| s == "Fom"}

	  #Works with multiple pages
	  page.css('span.detailWithoutWrap_j1kt73').each do |line|
	    type << line.text
	  end
	  type -= ["Fully refundable"]
	  type.delete_if {|s| s.include? "bed"}


	  #Works with multiple pages
	  page.css('span.detailWithoutWrap_j1kt73').each do |line|
	    beds << line.text
	  end
	  beds -= ["Fully refundable"]
	  beds.delete_if {|s| s.include? "room"}
	  beds.delete_if {|s| s.include? "Entire"}
	  beds = beds.map { |val|
	  	val = val.tr('beds', '')
	  	val.tr(' ', '')
	  }


	  #Works with multiple pages
	  page.css('div.statusContainer_sh3xmg').each do |line|
	    reviews << line.text
	  end
	  reviews = reviews.map { |val|
	  	val = val.tr('reviews', '')
	  	val = val.tr(' ', '')
	    val = val.tr('NEW', '')
	    if val.empty?
	      "0"
	    else
	      val
	    end
	  }

	  #works with multiple pages
	  page.css('div.container_e296pg div.image_ay4wjb-o_O-background_1h6n1zu-o_O-fadeIn_3jddj2-o_O-backgroundSize_contain_16d3go2').each do |line|
		  line = line.to_s
		  line = line.split('url(')
		  line = line[1].split(');')
		  line = line[0]
		  image_url << line
	  end
	end


	#delete old posts before saving new ones
		##needs to come after scraping loop,
		##to minimize the time that the database
		##is empty.
	Post.delete_all

	#save new posts to the database
	name.length.times do |i|
	  @post = Post.new
	  @post.heading = name[i]
	  @post.price = price[i]
	  @post.housing = type[i]
	  @post.beds = beds[i]
	  @post.reviews = reviews[i]
	  @post.image = image_url[i]
	  @post.save
	end
  end

  desc "TODO"
  task destroy_all_posts: :environment do
  	Post.delete_all
  end

end
