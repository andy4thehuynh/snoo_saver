# SavedHistory#sample returns 100 saved listings by default
# SavedHistory#all returns as many saved listings as it can.

class SavedHistory
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def sample
    paginator.format
  end

  def all
    listings = []
    count = 0

    page = paginator

    while page.more_listings?
      listings << page.format

      count += RedditIntegration::PAGE_LIMIT
      puts "listings count: #{count}"

      page = paginator(page.after_param, count)
    end

    listings.flatten
  end

  private

  def paginator(after = nil, count = nil)
    json = client.retrieve_history(after, count)
    ListingsPaginator.new(json) if json
  end

  def client
    @client ||= RedditIntegration.new(session)
  end
end

