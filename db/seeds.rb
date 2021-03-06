# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# pass passwords to db:reset, db:setup, or db:seed like so:
# `upw=myuserpassword apw=myadminpassword rails db:seed`
user_password = ENV['upw'] || ENV['user_password'] || SecureRandom.hex(14)
admin_password = ENV['apw'] || ENV['admin_password'] || user_password

puts 'Populating Feature Flags'
FeatureFlag.find_or_create_by(flag: 'mass_messages').update!(enabled: true)
FeatureFlag.find_or_create_by(flag: 'templates').update!(enabled: true)
FeatureFlag.find_or_create_by(flag: 'client_status').update!(enabled: true)

puts 'Populating Client Statuses'
ClientStatus.find_or_create_by!(name: 'Exited', followup_date: 90)
ClientStatus.find_or_create_by!(name: 'Training', followup_date: 30)
ClientStatus.find_or_create_by!(name: 'Active', followup_date: 30)

puts "Creating Admin User with password #{admin_password}"
AdminUser.find_or_create_by(email: 'admin@example.com').update!(password: admin_password, password_confirmation: admin_password) if Rails.env.development?

puts "Creating Test User with password #{user_password}"
test_user = User.find_or_create_by(email: 'test@example.com')
test_user.update!(full_name: 'Test Example', password: user_password, department: nil)

puts 'Deleting Old Records'
Message.delete_all
ReportingRelationship.delete_all
Client.delete_all
User.where.not(id: [test_user.id]).delete_all
Department.delete_all
Survey.delete_all

puts 'Creating Departments'
FactoryBot.create_list :department, 3
User.all.each do |user|
  user.update_attributes(department: Department.all.sample)
end

test_user.reload.department.update(phone_number: ENV['TWILIO_PHONE_NUMBER'])

puts 'Creating Survey Questions and Responses'
FactoryBot.create :survey_question
SurveyQuestion.all.each do |question|
  FactoryBot.create_list :survey_response, 6, survey_question: question
end

puts 'Creating Users and Clients'
Department.all.each do |department|
  FactoryBot.create_list :user, 3, department: department
  unclaimed_user = FactoryBot.create :user, full_name: 'Unclaimed User', department: department
  department.unclaimed_user = unclaimed_user
  department.save

  department.users.where.not(id: department.unclaimed_user.id).each do |user|
    FactoryBot.create_list :client, 5, user: user
  end
end

puts 'Fuzzing Clients'
Client.all.sample(15).each do |client|
  existing_users = client.users
  client.users << User.where.not(department: existing_users.map(&:department)).sample
end

puts 'Creating Messages'
ReportingRelationship.all.each do |rr|
  rr.update!(client_status_id: ClientStatus.all.sample.id)
  FactoryBot.create_list :message, 10, user: rr.user, client: rr.client
end
