User.delete_all
Candidate.create(:user_attributes => {name: 'Martin', lastname: 'Bomio', email: 'martinbomio@gmail.com', password: '12345'})
Employer.create(:user_attributes => {name: 'Martin', lastname: 'Bomio', email: 'martinbomio@hotmail.com', password: '12345'})
