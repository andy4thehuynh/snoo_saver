class SavedHistory
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def get_some_listings
    listing = page_history
    PageListing.new(listing).collect_listings
  end

  def get_all
    all_listings = []
    count = 0

    history_listings = page_history
    page_listing = PageListing.new(history_listings)

    while page_listing.fetchable?
      all_listings << page_listing.collect_listings

      count += RedditIntegration::PAGE_LIMIT

      history_listings = page_history(page_listing.after_param, count)
      page_listing = PageListing.new(history_listings) if history_listings
    end

    all_listings.flatten
  end

  private

  def page_history(after=nil, count=0)
    client.get_save_history(after, count)
  end

  def client
    @client ||= RedditIntegration.new(session)
  end
end

