puts "Creating 20 users..."

20.times do |i|
  AdminUser.create!(
    email: "usuario#{i+1}@example.com",
    password: "123456",
    password_confirmation: "123456"
  )
end

puts "Users created successfully!"
