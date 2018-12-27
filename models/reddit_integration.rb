class RedditIntegration
  PAGE_LIMIT = 100

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def get_save_history(after, count)
    client.get(path, limit: PAGE_LIMIT, after: after, count: count)
  end

  private

  def client
    request.client
  end

  def path
    "/user/#{name}/saved/"
  end

  def name
    request.me.name
  end
end
