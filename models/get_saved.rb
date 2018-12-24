class SavedContent
  PER_LISTING = 100

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def get_a_handfull
    blob = get_blob
    get_bookmarks(blob)
  end

  def get_all
    bookmarks = []
    count = 0

    blob = get_blob
    while after = blob.body[:data][:after]
      puts "added after: #{after}"
      bookmarks << get_bookmarks(blob)
      count += PER_LISTING
      blob = get_blob(after, count)
    end

    puts "count: #{count}"
    bookmarks.flatten
  end

  private

  def get_bookmarks(blob)
    blob.body[:data][:children].collect { |bm| bm[:data] }
  end

  def get_blob(after=nil, count=0)
    client.get(path, limit: PER_LISTING, after: after, count: count)
  end

  def path
    "/user/#{name}/saved/"
  end

  def client
    request.client
  end

  def name
    request.me.name
  end
end

