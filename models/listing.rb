class PageListing
  attr_reader :listing

  def initialize(listing)
    @listing = listing
  end

  def after_param
    listing.body[:data][:after]
  end

  def fetchable?
    after_param.present?
    # puts "nil: #{!after_param.nil?}"
    # puts "blank: #{after_param != ""}"
    # !after_param.nil? || after_param != ""
    # after_param != "" || listing.body.fetch(:data)
  end

  def collect_listings
    listing.body[:data][:children].collect { |bm| bm[:data] }
  end
end
