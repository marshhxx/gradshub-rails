Nationality.delete_all
[
    {:name => "Afghan"},
    {:name => "Albanian"},
    {:name => "Algerian"},
    {:name => "American"},
    {:name => "Andorran"},
    {:name => "Angolan"},
    {:name => "Argentine"},
    {:name => "Armenian"},
    {:name => "Aromanian"},
    {:name => "Aruban"},
    {:name => "Australian"},
    {:name => "Austrian"},
    {:name => "Azeri"},
    {:name => "Bahamian"},
    {:name => "Bahraini"},
    {:name => "Bangladeshi"},
    {:name => "Barbadian"},
    {:name => "Belarusian"},
    {:name => "Belgian"},
    {:name => "Belizean"},
    {:name => "Bermudian"},
    {:name => "Boer"},
    {:name => "Bosniak"},
    {:name => "Brazilian"},
    {:name => "Breton"},
    {:name => "British"},
    {:name => "British Virgin Islander"},
    {:name => "Bulgarian"},
    {:name => "Burmese"},
    {:name => "Macedonian Bulgarian"},
    {:name => "Burkinabè"},
    {:name => "Burundian"},
    {:name => "Cambodian"},
    {:name => "Cameroonian"},
    {:name => "Canadian"},
    {:name => "Catalan"},
    {:name => "Cape Verdean"},
    {:name => "Chadian"},
    {:name => "Chilean"},
    {:name => "Chinese"},
    {:name => "Colombian"},
    {:name => "Comorian"},
    {:name => "Congolese"},
    {:name => "Croatian"},
    {:name => "Cuban"},
    {:name => "Cypriot"},
    {:name => "Turkish Cypriot"},
    {:name => "Czech"},
    {:name => "Danes"},
    {:name => "Dominican (Republic)"},
    {:name => "Dominican (Commonwealth)"},
    {:name => "Dutch"},
    {:name => "East Timorese"},
    {:name => "Ecuadorian"},
    {:name => "Egyptian"},
    {:name => "Emirati"},
    {:name => "English"},
    {:name => "Eritrean"},
    {:name => "Estonian"},
    {:name => "Ethiopian"},
    {:name => "Faroese"},
    {:name => "Finn"},
    {:name => "Finnish Swedish"},
    {:name => "Fijian"},
    {:name => "Filipino"},
    {:name => "French citizen"},
    {:name => "Georgian"},
    {:name => "German"},
    {:name => "Baltic German"},
    {:name => "Ghanaian"},
    {:name => "Gibraltar"},
    {:name => "Greek"},
    {:name => "Greek Macedonian"},
    {:name => "Grenadian"},
    {:name => "Guatemalan"},
    {:name => "Guianese (French)"},
    {:name => "Guinean"},
    {:name => "Guinea-Bissau national"},
    {:name => "Guyanese"},
    {:name => "Haitians"},
    {:name => "Honduran"},
    {:name => "Hong Kong"},
    {:name => "Hungarian"},
    {:name => "Icelander"},
    {:name => "Indians"},
    {:name => "Indonesian"},
    {:name => "Iranian (Persians)"},
    {:name => "Arab"},
    {:name => "Irish"},
    {:name => "Israeli"},
    {:name => "Italian"},
    {:name => "Ivoirian"},
    {:name => "Jamaican"},
    {:name => "Japanese"},
    {:name => "Jordanian"},
    {:name => "Kazakh"},
    {:name => "Kenyan"},
    {:name => "Korean"},
    {:name => "Kosovo Albanian"},
    {:name => "Kurd"},
    {:name => "Kuwaiti"},
    {:name => "Lao"},
    {:name => "Latvian"},
    {:name => "Lebanese"},
    {:name => "Liberian"},
    {:name => "Libyan"},
    {:name => "Liechtensteiner"},
    {:name => "Lithuanian"},
    {:name => "Luxembourger"},
    {:name => "Macedonian"},
    {:name => "Malagasy"},
    {:name => "Malaysian"},
    {:name => "Malawian"},
    {:name => "Maldivian"},
    {:name => "Malian"},
    {:name => "Maltese"},
    {:name => "Manx"},
    {:name => "Mauritian"},
    {:name => "Mexican"},
    {:name => "Moldovan"},
    {:name => "Moroccan"},
    {:name => "Mongolian"},
    {:name => "Montenegrin"},
    {:name => "Namibian"},
    {:name => "Nepalese"},
    {:name => "New Zealander"},
    {:name => "Nicaraguan"},
    {:name => "Nigerien"},
    {:name => "Nigerian"},
    {:name => "Norwegian"},
    {:name => "Pakistani"},
    {:name => "Palauan"},
    {:name => "Palestinian"},
    {:name => "Panamanian"},
    {:name => "Papua New Guinean"},
    {:name => "Paraguayan"},
    {:name => "Peruvian"},
    {:name => "Pole"},
    {:name => "Portuguese"},
    {:name => "Puerto Rican"},
    {:name => "Quebecer"},
    {:name => "Réunionnai"},
    {:name => "Romanian"},
    {:name => "Russian"},
    {:name => "Baltic Russian"},
    {:name => "Rwandan"},
    {:name => "Salvadoran"},
    {:name => "São Tomé and Príncipe"},
    {:name => "Saudi"},
    {:name => "Scot"},
    {:name => "Senegalese"},
    {:name => "Serb"},
    {:name => "Sierra Leonean"},
    {:name => "Singaporean"},
    {:name => "Slovak"},
    {:name => "Slovene"},
    {:name => "Somali"},
    {:name => "South African"},
    {:name => "Spaniard"},
    {:name => "Sri Lankan"},
    {:name => "St Lucian"},
    {:name => "Sudanese"},
    {:name => "Surinamese"},
    {:name => "Swede"},
    {:name => "Swiss"},
    {:name => "Syrian"},
    {:name => "Taiwanese"},
    {:name => "Tanzanian"},
    {:name => "Thai"},
    {:name => "Tibetan"},
    {:name => "Tobagonian"},
    {:name => "Trinidadian"},
    {:name => "Tunisian"},
    {:name => "Turk"},
    {:name => "Tuvaluan"},
    {:name => "Ugandan"},
    {:name => "Ukrainian"},
    {:name => "Uruguayan"},
    {:name => "Uzbek"},
    {:name => "Vanuatuan"},
    {:name => "Venezuelan"},
    {:name => "Vietnamese"},
    {:name => "Welsh"},
    {:name => "Yemeni"},
    {:name => "Zambian"},
    {:name => "Zimbabwean"},
].each do |c|
  Nationality.create(:name => c[:name])
end