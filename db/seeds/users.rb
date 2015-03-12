User.delete_all
OnepgrAccount.delete_all
account = OnepgrAccount.create({onepgr_id: '1438', onepgr_password: '997680'})
Candidate.create(:user_attributes => {name: 'Martin', lastname: 'Bomio', email: 'martinbomio@gmail.com', password: '12345', onepgr_account_id: account.id})
other_acc = OnepgrAccount.create({onepgr_id: '1565', onepgr_password: '322448'})
Employer.create(:user_attributes => {name: 'Martin', lastname: 'Bomio', email: 'martinbomio@hotmail.com', password: '12345', onepgr_account_id: other_acc .id})
