# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Populating Feature Flags"
FeatureFlag.find_or_create_by(flag: 'mass_messages').update!(enabled: true)
FeatureFlag.find_or_create_by(flag: 'templates').update!(enabled: true)
FeatureFlag.find_or_create_by(flag: 'client_status').update!(enabled: true)

puts "Populating Client Statuses"
ClientStatus.find_or_create_by!(name: 'Exited', followup_date: 90)
ClientStatus.find_or_create_by!(name: 'Training', followup_date: 30)
ClientStatus.find_or_create_by!(name: 'Active', followup_date: 30)

puts "Creating Admin User"
AdminUser.find_or_create_by(email: 'admin@example.com').update!(password: 'changeme', password_confirmation: 'changeme') if Rails.env.development?

puts "Creating Test Users"
test_user = User.find_or_create_by(email: 'test@example.com')
test_user.update!(full_name: 'Test Example', password: 'changeme', department: nil)
unclaimed_user = User.find_or_create_by(email: ENV['UNCLAIMED_EMAIL'])
unclaimed_user.update!(full_name: 'Unclaimed Email', password: 'changeme', department: nil)


puts "Deleting Old Records"
Message.delete_all
ReportingRelationship.delete_all
Client.delete_all
User.where.not(id: [test_user.id, unclaimed_user.id]).delete_all
Department.delete_all

puts "Creating Departments"
FactoryGirl.create_list :department, 10
User.all.each do |user|
  user.update_attributes(department: Department.all.sample)
end

puts "Creating Sample Users"
5.times do
  FactoryGirl.create :user, department: Department.all.sample
end

puts "Creating Clients"
User.where.not(id: [unclaimed_user.id]).each do |user|
  FactoryGirl.create_list :client, 10, associated_user: user
end
Client.all.sample(5).each do |client|
  existing_users = client.users
  client.users << User.where.not(department: existing_users.map(&:department)).sample
end

puts "Creating Messages"
Client.all.each do |client|
  FactoryGirl.create_list :message, 10, user: client.users.sample, client: client
end
