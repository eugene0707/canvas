users = [{ email: Rails.application.secrets.admin_email,
           password: Rails.application.secrets.admin_password,
           profile: AdminProfile.new },
         { email: 'user@example.com',
           password: Rails.application.secrets.admin_password,
           profile: RegularProfile.new }]

users.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.profile = attrs[:profile]
    user.password = attrs[:password]
    user.confirm
    user.save
    puts 'CREATED USER: ' << attrs[:email]
  end
end
