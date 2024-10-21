# db/seeds.rb

# Define users to be created
users = [
  { email: 'jerry@apricotlaw.com', password: 'securepassword123', role: 'admin', logged_company_id: nil },
  { email: 'greensteinmilbauersocial@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 788957891 },
  { email: 'brocklawsocial@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 432770919 },
  { email: 'brownchiarillplawny@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 754688700 },
  { email: 'congerlawinjuryattysca@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 707808192 },
  { email: 'conwaypauleyjohnsonlawne@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 196651924 },
  { email: 'crowelllawofficesca@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 408997789 },
  { email: 'greenberglawsocial@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 435195417 },
  { email: 'klglawyerny@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 294642214 },
  { email: 'dkblawyerssocial@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 533921350 },
  { email: 'classociateslaw@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 316384868 },
  { email: 'lhpamaster@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 612344072 },
  { email: 'mahoneymahoneylaw@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 595022144 },
  { email: 'moneyfirstlendingnv@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 258732157 },
  { email: 'rozaslawfirmllcla@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 427975086 },
  { email: 'davidsmithlegal@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 847306783 },
  { email: 'ggt@gmail.com', password: 'securepassword123', role: 'client', logged_company_id: 123456789 }
]

# Create each user in the database
users.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.password = user_data[:password]
    user.role = user_data[:role]
    user.logged_company_id = user_data[:logged_company_id]
  end
end

puts "Seeded #{users.size} users successfully."
