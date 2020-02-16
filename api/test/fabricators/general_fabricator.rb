Fabricator(:setting) do
  keep_count '3'
  look_back_count '8'
  nebula_user 'go@mail.com'
  nebula_pass 'hunter2'
  nebula_cache(
    {
      public: {
        ZYPE_API_KEY: 'aaa'
      },
      user: {
        zype_auth_info: {
          access_token: 'bbb',
          expires_at: (Time.now + 100.days).to_i
        }
      }
    }.to_json
  )
end

Fabricator(:subscription_base, class_name: :subscription) do
  type 'YtSubscription'
  remote_id SecureRandom.hex
  url 'https://www.youtube.com/channel/UCg3qsVzHeUt5_cPpcRtoaJQ'
  title ' Kiwami Japan'
  thumbnail_url 'https://yt3.ggpht.com/a/AGF-l7-88Qk81fUw-e2ECXXbJMgo5RbwwtRx9Iw4XQ=s288-c-k-c0xffffffff-no-rj-mo'
  description <<~TEXT
    How to Sharpen a Kitchen knife,
    Whetstone,Experiment,Chemistry,
  TEXT
  video_count 24
  subscriber_count 100000
end

Fabricator(:subscription, from: :subscription_base) do
  videos(count: 5, fabricator: :video_base)
end

Fabricator(:video_base, class_name: :video) do
  type 'YtVideo'
  remote_id SecureRandom.hex
  published_at Time.at(1581863290).to_datetime
  title 'sharpest chocolate kitchen knife in the world'
  thumbnail_url 'https://i.ytimg.com/vi/D2XNVFlh-DU/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLBz1P9wTHBytoE_2oL1Xu64z8MMsA'
  duration 12345
  description <<~TEXT
    sharpest chocolate kitchen knife in the world
    ---
    Q, Is this a serial killer channel?
    A, Materials Science channel
    Normal person: “Hm, chocolate. I should make some candy.”
    Kawami: “Hm, chocolate. How many ways can I make to cut something with this?”
  TEXT
end

Fabricator(:video, from: :video_base) do
  subscription
end
