class RedditIntegration
  PAGE_LIMIT = 100

  attr_reader :session

  def initialize(session)
    @session = session
  end

  def get_save_history(after, count)
    client.get(path, limit: PAGE_LIMIT, after: after, count: count)
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
