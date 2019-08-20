class SlackMessageService
  def self.start_listening
    client = Slack::RealTime::Client.new(token: Settings.slack.bot_access_token)

    client.on :message do |data|
      SlackMessageService.respond_to_message(client, data)
    end

    client.start!
  end

  def self.respond_to_message(client, message)
    return unless message['client_msg_id'].present?

    lock = REDIS.lock("slack_message:#{message.fetch('client_msg_id')}:lock", 1.seconds.in_milliseconds)

    if lock.present?
      if has_pr_link?(message.text)
        process_pr_message(message)
      else
        case message.text.downcase
        when 'hi ninja' then
          client.web_client.chat_postMessage(channel: message.channel, text: "Hi <@#{message.user}>!")
        end
      end
    end
  end

  private_class_method def self.get_user_for_message(message)
    User.find_or_create_by!(slack_id: message.fetch('user'))
  end

  private_class_method def self.process_pr_message(message)
    pr_user = get_user_for_message(message)

    text = get_text_from_message(message)
    user_ids = get_user_ids_from_text(text).to_a
    pr_link = get_pr_link_from_text(text)

    pr_users = user_ids.map do |user_id|
      User.find_or_create_by!(slack_id: user_id.first)
    end

    pr = PullRequest.find_or_initialize_by(link: pr_link)
    pr.user = pr_user
    pr.description = get_description_from_text(text, user_ids, pr_link)
    pr.save!

    pr_users.each do |user|
      next if user.id == pr_user.id

      pr.tagged_users << user unless pr.tagged_user_ids.include?(user.id)
    end
  end

  private_class_method def self.regex_repo_name
    Settings.repo_partial.gsub('/', '\/')
  end

  private_class_method def self.get_description_from_text(text, user_ids, link)
    user_ids.map do |user_id|
      text = text.gsub("<@#{user_id.first}>", '')
    end
    text = text.gsub("<#{link}>", '')
    text = text.gsub(link, '')

    text.strip
  end

  private_class_method def self.get_pr_link_from_text(text)
    text.match(/(https:\/\/github.com#{regex_repo_name}pull\/\w*)/)[0]
  end

  private_class_method def self.has_pr_link?(text)
    text.match?(/(https:\/\/github.com#{regex_repo_name}pull\/\w*)/)
  end

  private_class_method def self.get_user_ids_from_text(text)
    text.scan(/<@(\w*)>/)
  end

  private_class_method def self.get_text_from_message(message)
    text = message.text

    text = if text.include?('<!subteam^')
      expand_user_groups(text)
    else
      text
    end
  end

  private_class_method def self.expand_user_groups(text)
    get_user_groups(text).each do |group_id|
      group_users = slack_client.usergroups_users_list(usergroup: group_id[0])

      text = text.gsub(/<!subteam\^#{group_id[0]}\|@\w*>/, group_users.fetch('users').map{|user_id| "<@#{user_id}>"}.join(' '))
    end

    text
  end

  private_class_method def self.get_user_groups(text)
    text.scan(/<!subteam\^(\w*)\|@\w*>/)
  end

  private_class_method def self.slack_client
    @slack_client ||= Slack::Web::Client.new(token: Settings.slack.access_token)
  end
end
