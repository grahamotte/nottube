subs = [
  "https://www.youtube.com/user/Fullscreen",
  "https://www.youtube.com/channel/UCpZ5qUqpW4hW4zdfuBxMSJA",
  "https://www.youtube.com/channel/UCdN4aXTrHAtfgbVG9HjBmxQ",
  "https://www.youtube.com/user/theloudmouth37",
  "https://www.youtube.com/channel/UCaO6VoaYJv4kS-TQO_M-N_g",
  "https://www.youtube.com/user/TEDtalksDirector/featured",
  "https://www.youtube.com/channel/UC4iHwI-LZm7uJyw2Bchk_dQ",
]

Subscription.destroy_all

subs.each do |sub|
  s = Subscription.create!(url: sub)
  s.refresh_metadata
  SyncVideosJob.perform_later(s.id)
end
