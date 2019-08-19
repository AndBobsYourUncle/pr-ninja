# Slack::RealTime.configure do |config|
#   config.concurrency = Slack::RealTime::Concurrency::Async
# end

Slack::RealTime::Client.configure do |config|
  # Return timestamp only for latest message object of each channel.
  config.start_options[:simple_latest] = true
  # Skip unread counts for each channel.
  config.start_options[:no_unreads] = true
  # Increase request timeout to 6 minutes.
  config.start_options[:request][:timeout] = 360
end
