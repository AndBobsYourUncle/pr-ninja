test_user = User.create(
  name: "Test User",
  slack_scopes: ["identity.basic"],
  slack_id: "UABCD123E",
  slack_team_id: "T123ABCDE"
)

pr_authors = (1..5).map do |num|
  if num % 2 == 0
    User.create(
      slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
    )
  else
    User.create(
      name: Faker::Name.unique.name,
      slack_scopes: ["identity.basic"],
      slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
      slack_team_id: "T123ABCDE"
    )
  end
end

tagged_users = (1..10).map do |num|
  if num % 2 == 0
    User.create(
      slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
    )
  else
    User.create(
      name: Faker::Name.unique.name,
      slack_scopes: ["identity.basic"],
      slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
      slack_team_id: "T123ABCDE"
    )
  end
end


(1..16).each do |_num|
  pr = PullRequest.create(
    link: "https://github.com/some/repo/pull/#{Faker::Number.number(digits: 4)}",
    description: Faker::Hipster.sentence(word_count: 10),
    user: pr_authors.sample
  )

  pr.tagged_users << test_user

  (1..2).each do |_num|
    pr.tagged_users << tagged_users.sample
  end
end

test_user.user_tags.each_with_index do |tagged_pr, index|
  next unless index % 3 == 0

  tagged_pr.reload

  tagged_pr.update_status!(:complete)
end
