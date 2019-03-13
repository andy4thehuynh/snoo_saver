# Parses json returned by reddit into digestable,
# formatted page listings.

class ListingsPaginator
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def after_param
    data[:after]
  end

  def more_listings?
    after_param.present?
  end

  def format
    data[:children].collect { |listing| listing[:data] }
  end

  private

  def data
    @data ||= json.body[:data]
  end
end
