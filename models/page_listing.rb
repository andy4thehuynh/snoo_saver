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
  end

  def collect_listings
    listing.body[:data][:children].collect { |bm| bm[:data] }
  end
end
