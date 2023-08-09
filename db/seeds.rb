# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# Create posts with associated comments and images
User.find_each do |user|
  50.times do |i|
    post = user.posts.new(
      caption: "Post #{i+1}",
    )
    post.image.attach(io: File.open(Rails.root.join('public', 'test1.jpg')), filename: "image.jpg")
    post.save

    # Create comments for each post
    3.times do |j|
      post.comments.create(
        user: user,
        content: "Comment #{j+1} on Post #{i+1}"
      )
    end
  end
end
