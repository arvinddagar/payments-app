User.find_or_create_by(email: "admin@example.com") do |u|
  u.admin = true
  u.password = "password"
end
