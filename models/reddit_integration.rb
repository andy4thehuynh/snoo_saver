# Initializes a client to retrieve saved history for a user.
#
# https://old.reddit.com/dev/api#GET_user_{username}_{where}
# https://old.reddit.com/dev/api#listings

class RedditIntegration
  PAGE_LIMIT = 100

  attr_reader :session

  def initialize(session)
    @session = session
  end

  def retrieve_history(after = nil, count = nil)
    client.get(
      path,
      limit: PAGE_LIMIT,
      after: after,
      count: count
    )
  end

  private

  def client
    session.client
  end

  def path
    "/user/#{name}/saved/"
  end

  def name
    session.me.name
  end
end
