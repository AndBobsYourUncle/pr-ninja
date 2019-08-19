test_user = User.create(
  name: "Test User",
  slack_scopes: ["identity.basic"],
  slack_id: "UABCD123E",
  slack_team_id: "T123ABCDE"
)

pr_authors = (1..3).map do |_num|
  User.create(
    name: Faker::Name.unique.name,
    slack_scopes: ["identity.basic"],
    slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
    slack_team_id: "T123ABCDE"
  )
end

tagged_users = (1..5).map do |_num|
  User.create(
    name: Faker::Name.unique.name,
    slack_scopes: ["identity.basic"],
    slack_id: "U#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
    slack_team_id: "T123ABCDE"
  )
end


(1..10).each do |_num|
  pr = PullRequest.create(
    link: "https://github.com/some/repo/pull/#{Faker::Number.number(digits: 4)}",
    description: Faker::Hipster.sentence(word_count: 10),
    user: pr_authors.sample
  )

  pr.users << test_user

  (1..2).each do |_num|
    pr.users << tagged_users.sample
  end
end
