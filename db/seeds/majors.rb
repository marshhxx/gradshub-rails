Major.delete_all
[
    {:id => 0, :name => "Other"},
    {:name => "Agriculture, Agriculture Operations, and Related Sciences"},
    {:name => "Architecture and Related Services"},
    {:name => "Area, Ethnic, Cultural, Gender, and Group Studies"},
    {:name => "Aviation"},
    {:name => "Biological and Biomedical Sciences"},
    {:name => "Business, Management, Marketing, and Related Support Services"},
    {:name => "Communication, Journalism, and Related Programs"},
    {:name => "Communications Technologies/technicians and Support Services"},
    {:name => "Computer and Information Sciences and Support Services"},
    {:name => "Construction Trades"},
    {:name => "Education"},
    {:name => "Engineering Technologies and Engineering-Related Fields"},
    {:name => "Engineering"},
    {:name => "English Language and Literature/letters"},
    {:name => "Family and Consumer Sciences/human Sciences"},
    {:name => "Foreign Languages, Literatures, and Linguistics"},
    {:name => "Health Professions and Related Programs"},
    {:name => "History"},
    {:name => "Homeland Security, Law Enforcement, Firefighting"},
    {:name => "Human Services"},
    {:name => "Legal Professions and Studies"},
    {:name => "Liberal Arts and Sciences Studies and Humanities"},
    {:name => "Library Science"},
    {:name => "Mathematics and Statistics"},
    {:name => "Mechanic and Repair Technologies/technicians"},
    {:name => "Military Technologies and Applied Sciences"},
    {:name => "Multi/interdisciplinary Studies"},
    {:name => "Natural Resources and Conservation"},
    {:name => "Parks, Recreation, Leisure, and Fitness Studies"},
    {:name => "Personal and Culinary Services"},
    {:name => "Philosophy and Religious Studies"},
    {:name => "Physical Sciences"},
    {:name => "Precision Production"},
    {:name => "Psychology"},
    {:name => "Science Technologies/technicians"},
    {:name => "Social Sciences"},
    {:name => "Theology and Religious Vocations"},
    {:name => "Transportation and Materials Moving"},
    {:name => "Visual and Performing Arts"}
].each do |c|
  Major.create(:name => c[:name])
end