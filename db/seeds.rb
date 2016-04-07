require 'random_data'

# Create Posts
50.times do
    # #1
    Post.create!(
    # #2
    title:  RandomData.random_sentence,
    body:   RandomData.random_paragraph
)
end
posts = Post.all

# Create Comments
# #3
100.times do
    Comment.create!(
    # #4
    post: posts.sample,
    body: RandomData.random_paragraph
)
end


Post.find_or_create_by(title: "How does this work", body: "It works only if you program it correctly.").comments.find_or_create_by(body: "My body is unique")

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
