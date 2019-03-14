class ListingWorker
  include Sidekiq::Worker

  def perform
    puts "background start"
    sleep 10
    puts "FINSIHED"
  end
end
