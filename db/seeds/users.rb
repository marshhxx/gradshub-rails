Candidate.delete_all
Employer.delete_all
User.delete_all
Candidate.create(:user_attributes => {name: 'Francisco', lastname: 'Cobas', email: 'candidate@gmail.com', password: 'pancho'})
#Employer.create(:user_attributes => {name: 'Martin', lastname: 'Bomio', email: 'martinbomio@hotmail.com', password: '12345'})
