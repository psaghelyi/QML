qmlVersion: "1.0"
questionnaire:
  title: "European Social Survey Round 12 (ESS12)"
  codeInit: |
    internet_frequent = 0
    voted = 0
    party_closer = 0
    born_in_country = 0
    has_religion = 0
    had_religion = 0
    father_working = 0
    mother_working = 0
    in_paid_work = 0
    had_paid_work = 0
    living_with_partner = 0
    cohabiting = 0
    has_partner_in_household = 0
    has_children_in_household = 0
    b16_multiple = 0
    b45_multiple = 0
    partner_in_paid_work = 0
    partner_had_paid_work = 0
    discriminated = 0
    assisted = 0
    recontact = 0

  blocks:

    # ─────────────────────────────────────────────
    # SECTION A — Social, Political, Climate Topics
    # ─────────────────────────────────────────────
    - id: b_section_a
      title: "Section A: Your Local Area and Society"
      items:

        - id: q_a1
          kind: Question
          title: "Overall, how satisfied or dissatisfied are you with your local area as a place to live?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Fairly satisfied"
              3: "Neither satisfied nor dissatisfied"
              4: "Fairly dissatisfied"
              5: "Very dissatisfied"

        - id: q_a2
          kind: Question
          title: "Over the past two years, has the local area where you live got better, worse, or not changed much?"
          input:
            control: Radio
            labels:
              1: "Got better"
              2: "Got worse"
              3: "Not changed much (has not got better or worse)"
              4: "I have not lived here long enough to say"

        - id: q_a3
          kind: Question
          title: "How much do you feel you belong to your local area? Please answer using a scale where 0 means not at all and 6 means a great deal."
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_a4
          kind: Question
          title: "How often do you chat to your neighbours, more than to just say hello?"
          input:
            control: Radio
            labels:
              1: "On most days"
              2: "Once or twice a week"
              3: "Once or twice a month"
              4: "Less than once a month"
              5: "Never"
              6: "I don't have any neighbours"

        - id: q_a5
          kind: Question
          title: "Do you think that climate change is caused by natural processes, human activity, or both?"
          input:
            control: Radio
            labels:
              1: "Entirely by natural processes"
              2: "Mainly by natural processes"
              3: "About equally by natural processes and human activity"
              4: "Mainly by human activity"
              5: "Entirely by human activity"
              6: "I don't think climate change is happening"

        - id: q_a6
          kind: Question
          title: "To what extent do you feel a personal responsibility to try to reduce climate change? Please answer on a scale of 0 (not at all) to 10 (a great deal)."
          precondition:
            - predicate: q_a5.outcome != 6
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all"
            right: "A great deal"

        - id: q_a7
          kind: Question
          title: "How worried are you about climate change?"
          precondition:
            - predicate: q_a5.outcome != 6
          input:
            control: Radio
            labels:
              1: "Not at all worried"
              2: "Not very worried"
              3: "Somewhat worried"
              4: "Very worried"
              5: "Extremely worried"

        - id: q_a8_hours
          kind: Question
          title: "On a typical day, about how much time do you spend in hours watching, reading or listening to news about politics and current affairs? (Hours, 0-24)"
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours"
          postcondition:
            - predicate: q_a8_hours.outcome >= 0 and q_a8_hours.outcome <= 24
              hint: "Please enter a number between 0 and 24 hours."

        - id: q_a8_minutes
          kind: Question
          title: "On a typical day, about how much time do you spend in minutes (in addition to hours above) watching, reading or listening to news about politics and current affairs? (Minutes, 0-59)"
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes"
          postcondition:
            - predicate: q_a8_minutes.outcome >= 0 and q_a8_minutes.outcome <= 59
              hint: "Please enter a number between 0 and 59 minutes."

        - id: q_a9
          kind: Question
          title: "People can use the internet on different devices such as computers, tablets and smartphones. How often do you use the internet on these or any other devices, whether for work or personal use?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Only occasionally"
              3: "A few times a week"
              4: "Most days"
              5: "Every day"
          codeBlock: |
            if q_a9.outcome >= 4:
                internet_frequent = 1

        - id: q_a10_hours
          kind: Question
          title: "On a typical day, about how much time in hours do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use? (Hours, 0-24)"
          precondition:
            - predicate: internet_frequent == 1
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours"
          postcondition:
            - predicate: q_a10_hours.outcome >= 0 and q_a10_hours.outcome <= 24
              hint: "Please enter a number between 0 and 24 hours."

        - id: q_a10_minutes
          kind: Question
          title: "On a typical day, about how much time in minutes (in addition to hours) do you spend using the internet? (Minutes, 0-59)"
          precondition:
            - predicate: internet_frequent == 1
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes"

        - id: q_a11
          kind: Question
          title: "Generally speaking, would you say that most people can be trusted, or that you can't be too careful in dealing with people? (0 = you can't be too careful, 10 = most people can be trusted)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "You can't be too careful"
            right: "Most people can be trusted"

        - id: q_a12
          kind: Question
          title: "Do you think that most people would try to take advantage of you if they got the chance, or would they try to be fair? (0 = most people would try to take advantage, 10 = most people would try to be fair)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Most people would try to take advantage of me"
            right: "Most people would try to be fair"

        - id: q_a13
          kind: Question
          title: "Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves? (0 = people mostly look out for themselves, 10 = people mostly try to be helpful)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "People mostly look out for themselves"
            right: "People mostly try to be helpful"

        - id: q_a14
          kind: Question
          title: "How interested would you say you are in politics?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Quite interested"
              3: "Hardly interested"
              4: "Not at all interested"

        - id: q_a15
          kind: Question
          title: "How much would you say the political system in your country allows people like you to have a say in what the government does?"
          input:
            control: Radio
            labels:
              1: "Not at all"
              2: "Very little"
              3: "Some"
              4: "A lot"
              5: "A great deal"

        - id: q_a16
          kind: Question
          title: "How able do you think you are to take an active role in a group involved with political issues?"
          input:
            control: Radio
            labels:
              1: "Not at all able"
              2: "A little able"
              3: "Quite able"
              4: "Very able"
              5: "Completely able"

        - id: q_a17
          kind: Question
          title: "How much would you say the political system in your country allows people like you to have an influence on politics?"
          input:
            control: Radio
            labels:
              1: "Not at all"
              2: "Very little"
              3: "Some"
              4: "A lot"
              5: "A great deal"

        - id: q_a18
          kind: Question
          title: "How confident are you in your own ability to participate in politics?"
          input:
            control: Radio
            labels:
              1: "Not at all confident"
              2: "A little confident"
              3: "Quite confident"
              4: "Very confident"
              5: "Completely confident"

        - id: q_a19
          kind: Question
          title: "How much do you personally trust your country's parliament? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a20
          kind: Question
          title: "How much do you personally trust the legal system? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a21
          kind: Question
          title: "How much do you personally trust the police? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a22
          kind: Question
          title: "How much do you personally trust politicians? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a23
          kind: Question
          title: "How much do you personally trust political parties? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a24
          kind: Question
          title: "How much do you personally trust the European Parliament? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a25
          kind: Question
          title: "How much do you personally trust the United Nations? (0 = no trust at all, 10 = complete trust)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"

        - id: q_a26
          kind: Question
          title: "Some people don't vote nowadays for one reason or another. Did you vote in the last national election in your country?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not eligible to vote"
          codeBlock: |
            if q_a26.outcome == 1:
                voted = 1

        - id: q_a27
          kind: Question
          title: "Which party did you vote for in the last national election?"
          precondition:
            - predicate: voted == 1
          input:
            control: Textarea
            placeholder: "Please write in the party name"
            maxLength: 200

        - id: q_a28
          kind: Question
          title: "During the last 12 months, have you contacted a politician, government or local government official?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a29
          kind: Question
          title: "During the last 12 months, have you donated to or participated in a political party or pressure group?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a30
          kind: Question
          title: "During the last 12 months, have you worn or displayed a campaign badge/sticker?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a31
          kind: Question
          title: "During the last 12 months, have you signed a petition?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a32
          kind: Question
          title: "During the last 12 months, have you taken part in a public demonstration?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a33
          kind: Question
          title: "During the last 12 months, have you boycotted certain products?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a34
          kind: Question
          title: "During the last 12 months, have you posted or shared anything about politics online, for example on blogs, via email or on social media such as Facebook, Instagram, TikTok, or X (formerly known as Twitter)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a35
          kind: Question
          title: "During the last 12 months, have you volunteered for a not-for-profit or charitable organisation?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a36
          kind: Question
          title: "Is there a particular political party you feel closer to than all the other parties?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_a36.outcome == 1:
                party_closer = 1

        - id: q_a37
          kind: Question
          title: "Which political party do you feel closest to?"
          precondition:
            - predicate: party_closer == 1
          input:
            control: Textarea
            placeholder: "Please write in the party name"
            maxLength: 200

        - id: q_a38
          kind: Question
          title: "How close do you feel to this party?"
          precondition:
            - predicate: party_closer == 1
          input:
            control: Radio
            labels:
              1: "Very close"
              2: "Quite close"
              3: "Not close"
              4: "Not at all close"

        - id: q_a39
          kind: Question
          title: "In politics people sometimes talk of 'left' and 'right'. Where would you place yourself on this scale, where 0 means the left and 10 means the right?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Left"
            right: "Right"

        - id: q_a40
          kind: Question
          title: "All things considered, how satisfied are you with your life as a whole nowadays? (0 = extremely dissatisfied, 10 = extremely satisfied)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        - id: q_a41
          kind: Question
          title: "On the whole, how satisfied are you with the present state of the economy in your country? (0 = extremely dissatisfied, 10 = extremely satisfied)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        - id: q_a42
          kind: Question
          title: "Now thinking about the government, how satisfied are you with the way it is doing its job? (0 = extremely dissatisfied, 10 = extremely satisfied)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        - id: q_a43
          kind: Question
          title: "And on the whole, how satisfied are you with the way democracy works in your country? (0 = extremely dissatisfied, 10 = extremely satisfied)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        - id: q_a44
          kind: Question
          title: "What do you think overall about the state of education in your country nowadays? (0 = extremely bad, 10 = extremely good)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

        - id: q_a45
          kind: Question
          title: "What do you think overall about the state of health services in your country nowadays? (0 = extremely bad, 10 = extremely good)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

        - id: q_a46
          kind: Question
          title: "The government should take measures to reduce differences in income levels."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a47
          kind: Question
          title: "Gay men and lesbians should be free to live their own life as they wish."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a48
          kind: Question
          title: "If a close family member was a gay man or a lesbian, I would feel ashamed."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a49
          kind: Question
          title: "Gay male and lesbian couples should have the same rights to adopt children as straight couples."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a50
          kind: Question
          title: "Now thinking about the European Union, some say European unification should go further. Others say it has already gone too far. Which number on this scale best describes your position? (0 = unification has already gone too far, 10 = unification should go further)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Unification has already gone too far"
            right: "Unification should go further"

        - id: q_a51
          kind: Question
          title: "Obedience and respect for authority are the most important values children should learn."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a52
          kind: Question
          title: "What your country needs most is loyalty towards its leaders."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_a53
          kind: Question
          title: "To what extent do you think your country should allow people of the same race or ethnic group as most people in your country to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_a54
          kind: Question
          title: "To what extent do you think your country should allow people of a different race or ethnic group from most people in your country to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_a55
          kind: Question
          title: "To what extent do you think your country should allow people from poorer countries outside Europe to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_a56
          kind: Question
          title: "To what extent do you think your country should allow people who are forced to leave their country because of armed conflict or persecution to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_a57
          kind: Question
          title: "Would you say it is generally bad or good for your country's economy that people come to live here from other countries? (0 = bad for the economy, 10 = good for the economy)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Bad for the economy"
            right: "Good for the economy"

        - id: q_a58
          kind: Question
          title: "Would you say that your country's cultural life is generally undermined or enriched by people coming to live here from other countries? (0 = cultural life undermined, 10 = cultural life enriched)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Cultural life undermined"
            right: "Cultural life enriched"

        - id: q_a59
          kind: Question
          title: "Is your country made a worse or a better place to live by people coming to live here from other countries? (0 = worse place to live, 10 = better place to live)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Worse place to live"
            right: "Better place to live"

        - id: q_a60
          kind: Question
          title: "Taking all things together, how happy would you say you are? (0 = extremely unhappy, 10 = extremely happy)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unhappy"
            right: "Extremely happy"

        - id: q_a61
          kind: Question
          title: "How often do you meet socially with friends, relatives or work colleagues?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "Several times a month"
              5: "Once a week"
              6: "Several times a week"
              7: "Every day"

        - id: q_a62
          kind: Question
          title: "How many people, if any, are there with whom you can discuss intimate and personal matters?"
          input:
            control: Radio
            labels:
              0: "None"
              1: "1"
              2: "2"
              3: "3"
              4: "4-6"
              5: "7-9"
              6: "10 or more"

        - id: q_a63
          kind: Question
          title: "Compared to other people of your age, how often would you say you take part in social activities?"
          input:
            control: Radio
            labels:
              1: "Much less than most"
              2: "Less than most"
              3: "About the same"
              4: "More than most"
              5: "Much more than most"

        - id: q_a64
          kind: Question
          title: "Have you or a member of your household been the victim of a burglary or assault in the last 5 years?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a65
          kind: Question
          title: "How safe do you – or would you – feel walking alone in the area you live after dark?"
          input:
            control: Radio
            labels:
              1: "Very safe"
              2: "Safe"
              3: "Unsafe"
              4: "Very unsafe"

        - id: q_a66
          kind: Question
          title: "How is your health in general?"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Fair"
              4: "Bad"
              5: "Very bad"

        - id: q_a67
          kind: Question
          title: "Are you hampered in your daily activities in any way by any longstanding illness, or disability, infirmity or mental health problem?"
          input:
            control: Radio
            labels:
              1: "Yes, a lot"
              2: "Yes, to some extent"
              3: "No"

        - id: q_a68
          kind: Question
          title: "How emotionally attached do you feel to your country? (0 = not at all emotionally attached, 10 = very emotionally attached)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all emotionally attached"
            right: "Very emotionally attached"

        - id: q_a69
          kind: Question
          title: "And how emotionally attached do you feel to Europe? (0 = not at all emotionally attached, 10 = very emotionally attached)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all emotionally attached"
            right: "Very emotionally attached"

        - id: q_a70
          kind: Question
          title: "Do you consider yourself as belonging to any particular religion or denomination?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_a70.outcome == 1:
                has_religion = 1

        - id: q_a71
          kind: Question
          title: "Which religion or denomination do you belong to?"
          precondition:
            - predicate: has_religion == 1
          input:
            control: Textarea
            placeholder: "Please write in your religion or denomination"
            maxLength: 200

        - id: q_a72
          kind: Question
          title: "Have you ever considered yourself as belonging to any particular religion or denomination?"
          precondition:
            - predicate: has_religion == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_a72.outcome == 1:
                had_religion = 1

        - id: q_a73
          kind: Question
          title: "Which religion or denomination did you belong to in the past?"
          precondition:
            - predicate: had_religion == 1
          input:
            control: Textarea
            placeholder: "Please write in your past religion or denomination"
            maxLength: 200

        - id: q_a74
          kind: Question
          title: "Regardless of whether you belong to a particular religion, how religious would you say you are? (0 = not at all religious, 10 = very religious)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all religious"
            right: "Very religious"

        - id: q_a75
          kind: Question
          title: "Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

        - id: q_a76
          kind: Question
          title: "Apart from when you are at religious services, how often, if at all, do you pray?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

        - id: q_a77
          kind: Question
          title: "Would you describe yourself as being a member of a group that is discriminated against in this country?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_a77.outcome == 1:
                discriminated = 1

        - id: q_a78
          kind: Question
          title: "On what grounds is your group discriminated against? (Select all that apply)"
          precondition:
            - predicate: discriminated == 1
          input:
            control: Checkbox
            labels:
              1: "Colour or race"
              2: "Nationality"
              4: "Religion"
              8: "Language"
              16: "Ethnic group"
              32: "Age"
              64: "Gender"
              128: "Sexuality"
              256: "Disability"
              512: "Other"

        - id: q_a79
          kind: Question
          title: "Are you a citizen of your country?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a80
          kind: Question
          title: "Were you born in your country?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_a80.outcome == 1:
                born_in_country = 1

        - id: q_a81
          kind: Question
          title: "In which country were you born?"
          precondition:
            - predicate: born_in_country == 0
          input:
            control: Textarea
            placeholder: "Please write in the country"
            maxLength: 100

        - id: q_a82
          kind: Question
          title: "What year did you first come to live in this country?"
          precondition:
            - predicate: born_in_country == 0
          input:
            control: Editbox
            min: 1900
            max: 2026
          postcondition:
            - predicate: q_a82.outcome >= 1900 and q_a82.outcome <= 2026
              hint: "Please enter a valid year between 1900 and the current year."

        - id: q_a83
          kind: Question
          title: "What language or languages do you speak most often at home? (Language 1)"
          input:
            control: Textarea
            placeholder: "Please write in the language"
            maxLength: 100

        - id: q_a83b
          kind: Question
          title: "What language or languages do you speak most often at home? (Language 2, if applicable)"
          input:
            control: Textarea
            placeholder: "Please write in the second language, or leave blank"
            maxLength: 100

        - id: q_a84
          kind: Question
          title: "Do you feel you are part of the same race or ethnic group as most people in your country?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_a85
          kind: Question
          title: "Was your father born in your country?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        - id: q_a86
          kind: Question
          title: "In which country was your father born?"
          precondition:
            - predicate: q_a85.outcome == 2
          input:
            control: Textarea
            placeholder: "Please write in the country"
            maxLength: 100

        - id: q_a87
          kind: Question
          title: "Was your mother born in your country?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        - id: q_a88
          kind: Question
          title: "In which country was your mother born?"
          precondition:
            - predicate: q_a87.outcome == 2
          input:
            control: Textarea
            placeholder: "Please write in the country"
            maxLength: 100

        - id: q_a89
          kind: Question
          title: "Imagine there were a referendum in your country tomorrow about membership of the European Union. Would you vote for your country to remain a member or to leave the European Union (or for your country to become a member or remain outside)?"
          input:
            control: Radio
            labels:
              1: "Remain a member / Become a member"
              2: "Leave the European Union / Remain outside"
              3: "Would submit a blank ballot paper"
              4: "Would spoil the ballot paper"
              5: "Would not vote"
              6: "Not eligible to vote"

    # ─────────────────────────────────────────────────
    # SECTION B — Household and Personal Demographics
    # ─────────────────────────────────────────────────
    - id: b_section_b
      title: "Section B: About You and Your Household"
      items:

        - id: q_b1
          kind: Question
          title: "Including yourself and any children, how many people live here regularly as members of your household?"
          input:
            control: Editbox
            min: 1
            max: 99
          postcondition:
            - predicate: q_b1.outcome >= 1 and q_b1.outcome <= 99
              hint: "Please enter a number between 1 and 99."

        - id: q_b2
          kind: Question
          title: "And how many of the people in your household are aged 15 or older, including yourself?"
          input:
            control: Editbox
            min: 1
            max: 99
          postcondition:
            - predicate: q_b2.outcome >= 1
              hint: "Your answer should be greater than zero."
            - predicate: q_b2.outcome <= q_b1.outcome
              hint: "The number of household members aged 15 or older should be less than or equal to the total number of household members."

        - id: q_b3
          kind: Question
          title: "What is your sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_b4_year
          kind: Question
          title: "In which year were you born?"
          input:
            control: Editbox
            min: 1900
            max: 2011
          postcondition:
            - predicate: q_b4_year.outcome >= 1900 and q_b4_year.outcome <= 2011
              hint: "Please enter a valid year of birth (4 digits)."

        - id: q_b4_month
          kind: Question
          title: "In which month were you born? (01 = January, 12 = December)"
          input:
            control: Editbox
            min: 1
            max: 12
          postcondition:
            - predicate: q_b4_month.outcome >= 1 and q_b4_month.outcome <= 12
              hint: "Please enter a valid month of birth (01-12)."

        # ── B5-B7: Household roster (one representative other member) ──
        # PDF: B5-B7 are repeated for up to 8 other household members.
        # QML limitation: dynamic loops are not supported, so we represent
        # one other household member. The key routing variable (relationship
        # to respondent) is captured here to gate downstream questions.

        - id: q_b5
          kind: Question
          title: "What is the sex of the other person in your household (Person 1)?"
          precondition:
            - predicate: q_b1.outcome >= 2
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_b6_month
          kind: Question
          title: "In which month was this person (Person 1) born? (01-12)"
          precondition:
            - predicate: q_b1.outcome >= 2
          input:
            control: Editbox
            min: 1
            max: 12
          postcondition:
            - predicate: q_b6_month.outcome >= 1 and q_b6_month.outcome <= 12
              hint: "Please enter a valid month of birth (01-12)."

        - id: q_b6_year
          kind: Question
          title: "In which year was this person (Person 1) born? (4 digits)"
          precondition:
            - predicate: q_b1.outcome >= 2
          input:
            control: Editbox
            min: 1900
            max: 2026
          postcondition:
            - predicate: q_b6_year.outcome >= 1900 and q_b6_year.outcome <= 2026
              hint: "Please enter a valid year of birth in full (4 digits)."

        - id: q_b7
          kind: Question
          title: "What is this person's (Person 1's) relationship to you? This person is your..."
          precondition:
            - predicate: q_b1.outcome >= 2
          input:
            control: Radio
            labels:
              1: "Husband, wife, or partner"
              2: "Son or daughter (including step, adopted, foster, or child of partner)"
              3: "Parent, parent-in-law, partner's parent, or step parent"
              4: "Brother or sister (including step, adopted, or foster)"
              5: "Other relative"
              6: "Other non-relative"
          codeBlock: |
            if q_b7.outcome == 1:
                has_partner_in_household = 1
            if q_b7.outcome == 2:
                has_children_in_household = 1

        # ── B8-B12: Marital status and partner details ──

        - id: q_b8
          kind: Question
          title: "Which one of the following descriptions best describes your relationship to your husband, wife, or partner?"
          precondition:
            - predicate: has_partner_in_household == 1
          input:
            control: Radio
            labels:
              1: "Legally married"
              2: "In a legally registered civil union"
              3: "Living with my partner (cohabiting) - not legally recognised"
              4: "Living with my partner (cohabiting) - legally recognised"
              5: "Legally separated"
              6: "Legally divorced or civil union dissolved"
              7: "Option 7 (country-specific)"
              8: "Option 8 (country-specific)"
          codeBlock: |
            if q_b8.outcome == 1 or q_b8.outcome == 2:
                living_with_partner = 1
            if q_b8.outcome == 3 or q_b8.outcome == 4:
                cohabiting = 1

        - id: q_b9
          kind: Question
          title: "Have you ever lived with a partner without being married to them?"
          precondition:
            - predicate: has_partner_in_household == 0 or (has_partner_in_household == 1 and q_b8.outcome in [1, 2, 5, 6, 7, 8])
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b10
          kind: Question
          title: "Have you ever been divorced or had a civil union dissolved?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b11
          kind: Question
          title: "This question is about your legal marital status. Which of the descriptions from the following list describes your legal marital status now?"
          precondition:
            - predicate: has_partner_in_household == 0 or cohabiting == 1
          input:
            control: Radio
            labels:
              1: "Legally married"
              2: "In a legally registered civil union"
              3: "Legally separated"
              4: "Legally divorced or civil union dissolved"
              5: "Widowed or civil partner died"
              6: "None of these (NEVER married or in legally registered civil union)"
              7: "Option 7 (country-specific)"
              8: "Option 8 (country-specific)"

        - id: q_b12
          kind: Question
          title: "Have you ever had any children of your own, step-children, adopted children, foster children or a partner's children living in your household?"
          precondition:
            - predicate: has_children_in_household == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b13
          kind: Question
          title: "Which of the following phrases best describes the area where you live?"
          input:
            control: Radio
            labels:
              1: "A big city"
              2: "The suburbs or outskirts of a big city"
              3: "A town or a small city"
              4: "A country village"
              5: "A farm or home in the countryside"

        - id: q_b14
          kind: Question
          title: "What is the highest level of education you have completed? (Country-specific education level)"
          input:
            control: Dropdown
            labels:
              1: "Level 1 (lowest)"
              2: "Level 2"
              3: "Level 3"
              4: "Level 4"
              5: "Level 5"
              6: "Level 6"
              7: "Level 7"
              8: "Level 8"
              9: "Level 9"
              10: "Level 10"
              11: "Level 11"
              12: "Level 12"
              13: "Level 13"
              14: "Level 14"
              15: "Level 15"
              16: "Level 16"
              17: "Level 17"
              18: "Level 18"
              19: "Level 19"
              20: "Level 20"
              21: "Level 21"
              22: "Level 22"
              23: "Level 23"
              24: "Level 24 (highest)"

        - id: q_b15
          kind: Question
          title: "About how many years of education have you completed, whether full-time or part-time?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        - id: q_b16
          kind: Question
          title: "Which of the following descriptions applies to what you have been doing for the last 7 days? (Select all that apply)"
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education, not paid for by employer"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or other persons"
              256: "Other"
          codeBlock: |
            if q_b16.outcome % 2 == 1:
                in_paid_work = 1
            if q_b16.outcome > 0 and (q_b16.outcome & (q_b16.outcome - 1)) != 0:
                b16_multiple = 1

        - id: q_b17
          kind: Question
          title: "And which of these descriptions best describes your situation in the last 7 days? (Please select only one)"
          precondition:
            - predicate: b16_multiple == 1
          input:
            control: Dropdown
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education, not paid for by employer"
              3: "Unemployed and actively looking for a job"
              4: "Unemployed, wanting a job but not actively looking"
              5: "Permanently sick or disabled"
              6: "Retired"
              7: "In community or military service"
              8: "Doing housework, looking after children or other persons"
              9: "Other"

        - id: q_b18
          kind: Question
          title: "Just to check, did you do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: in_paid_work == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_b18.outcome == 1:
                in_paid_work = 1

        - id: q_b19
          kind: Question
          title: "Have you ever had a paid job?"
          precondition:
            - predicate: in_paid_work == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_b19.outcome == 1:
                had_paid_work = 1

        - id: q_b20
          kind: Question
          title: "In what year were you last in a paid job?"
          precondition:
            - predicate: had_paid_work == 1 and in_paid_work == 0
          input:
            control: Editbox
            min: 1900
            max: 2026
          postcondition:
            - predicate: q_b20.outcome >= 1900 and q_b20.outcome <= 2026
              hint: "Please provide a year between 1900 and the current year."

        - id: q_b21
          kind: Question
          title: "In your main job, are/were you an employee, self-employed, or working for your family's business?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for your own family's business"

        - id: q_b22
          kind: Question
          title: "How many employees do/did you have?"
          precondition:
            - predicate: (in_paid_work == 1 or had_paid_work == 1) and q_b21.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999

        - id: q_b23
          kind: Question
          title: "Do/did you have a work contract of..."
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Radio
            labels:
              1: "Unlimited duration"
              2: "Limited duration"
              3: "No contract at all"

        - id: q_b24
          kind: Question
          title: "Including yourself, about how many people are/were employed at the place where you usually work/worked?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Radio
            labels:
              1: "Under 10"
              2: "10 to 24"
              3: "25 to 99"
              4: "100 to 499"
              5: "500 or more"

        - id: q_b25
          kind: Question
          title: "In your main job, do/did you have any responsibility for supervising the work of other employees?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b26
          kind: Question
          title: "How many people are/were you responsible for?"
          precondition:
            - predicate: (in_paid_work == 1 or had_paid_work == 1) and q_b25.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999

        - id: q_b27
          kind: Question
          title: "How much does/did the management at your work allow you to decide how your own daily work is/was organised? (0 = I have/had no influence, 10 = I have/had complete control)"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Slider
            min: 0
            max: 10
            left: "No influence"
            right: "Complete control"

        - id: q_b28
          kind: Question
          title: "How much does/did the management at your work allow you to influence policy decisions about the activities of the organisation? (0 = I have/had no influence, 10 = I have/had complete control)"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Slider
            min: 0
            max: 10
            left: "No influence"
            right: "Complete control"

        - id: q_b29
          kind: Question
          title: "What are/were your total 'basic' or contracted hours each week in your main job? (Excluding overtime, 0-168)"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"
          postcondition:
            - predicate: q_b29.outcome >= 0 and q_b29.outcome <= 168
              hint: "Please enter a number between 0 and 168 hours."

        - id: q_b30
          kind: Question
          title: "Regardless of your basic or contracted hours, how many hours do/did you normally work a week in your main job, including any paid or unpaid overtime? (0-168)"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"
          postcondition:
            - predicate: q_b30.outcome >= 0 and q_b30.outcome <= 168
              hint: "Please enter a number between 0 and 168 hours."

        - id: q_b31
          kind: Question
          title: "What does/did the firm or organisation you work/worked for mainly make or do?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Textarea
            placeholder: "Please give as much detail as you can"
            maxLength: 500

        - id: q_b32
          kind: Question
          title: "Which of the following types of organisation do/did you work for?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Radio
            labels:
              1: "Central or local government"
              2: "Other public sector (such as education and health)"
              3: "A state-owned enterprise"
              4: "A private firm"
              5: "Self-employed"
              6: "Other"

        - id: q_b33
          kind: Question
          title: "What is/was your main job?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Textarea
            placeholder: "Please be as specific as possible"
            maxLength: 300

        - id: q_b34
          kind: Question
          title: "What do/did you mainly do in this job?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Textarea
            placeholder: "Please describe your main duties"
            maxLength: 300

        - id: q_b35
          kind: Question
          title: "What training or qualifications are/were needed for this job?"
          precondition:
            - predicate: in_paid_work == 1 or had_paid_work == 1
          input:
            control: Textarea
            placeholder: "If no specific training or qualifications are needed, please write 'None'"
            maxLength: 300

        - id: q_b36
          kind: Question
          title: "In the last 10 years have you done any paid work in another country for a period of 6 months or more?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b37
          kind: Question
          title: "Have you ever been unemployed and seeking work for a period of more than 3 months?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b38
          kind: Question
          title: "Have any of these periods of unemployment lasted for 12 months or more?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b39
          kind: Question
          title: "Have any of these periods of unemployment, that lasted more than 3 months, been within the past 5 years?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b40
          kind: Question
          title: "Are you or have you ever been a member of a trade union or similar organisation?"
          input:
            control: Radio
            labels:
              1: "Yes, currently"
              2: "Yes, previously"
              3: "No"

        - id: q_b41
          kind: Question
          title: "Please consider the income of all household members and any income which may be received by the household as a whole. What is the main source of income in your household?"
          input:
            control: Radio
            labels:
              1: "Wages or salaries"
              2: "Income from self-employment (excluding farming)"
              3: "Income from farming"
              4: "Pensions"
              5: "Unemployment/redundancy benefit"
              6: "Any other social benefits or grants"
              7: "Income from investment, savings, insurance or property"
              8: "Income from other sources"

        - id: q_b42
          kind: Question
          title: "Using the income categories below, which best describes your household's total income, after tax and compulsory deductions, from all sources?"
          input:
            control: Radio
            labels:
              1: "Decile 1 (lowest)"
              2: "Decile 2"
              3: "Decile 3"
              4: "Decile 4"
              5: "Decile 5"
              6: "Decile 6"
              7: "Decile 7"
              8: "Decile 8"
              9: "Decile 9"
              10: "Decile 10 (highest)"

        - id: q_b43
          kind: Question
          title: "Which of the following descriptions comes closest to how you feel about your household's income nowadays?"
          input:
            control: Radio
            labels:
              1: "Living comfortably on present income"
              2: "Coping on present income"
              3: "Finding it difficult on present income"
              4: "Finding it very difficult on present income"

        # ── B44-B52: Partner's employment sub-section ──
        # PDF: ASK IF LIVING WITH HUSBAND/WIFE/PARTNER AT B7 (IF 01 AT B7)

        - id: q_b44a
          kind: Question
          title: "What is the highest level of education your husband, wife, or partner completed? (Country-specific education level)"
          precondition:
            - predicate: has_partner_in_household == 1
          input:
            control: Dropdown
            labels:
              1: "Level 1 (lowest)"
              2: "Level 2"
              3: "Level 3"
              4: "Level 4"
              5: "Level 5"
              6: "Level 6"
              7: "Level 7"
              8: "Level 8"
              9: "Level 9"
              10: "Level 10"
              11: "Level 11"
              12: "Level 12"
              13: "Level 13"
              14: "Level 14"
              15: "Level 15"
              16: "Level 16"
              17: "Level 17"
              18: "Level 18"
              19: "Level 19"
              20: "Level 20"
              21: "Level 21"
              22: "Level 22"
              23: "Level 23"
              24: "Level 24 (highest)"

        - id: q_b45
          kind: Question
          title: "Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days? (Select all that apply)"
          precondition:
            - predicate: has_partner_in_household == 1
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education, not paid for by employer"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or other persons"
              256: "Other"
          codeBlock: |
            if q_b45.outcome % 2 == 1:
                partner_in_paid_work = 1
            if q_b45.outcome > 0 and (q_b45.outcome & (q_b45.outcome - 1)) != 0:
                b45_multiple = 1

        - id: q_b46
          kind: Question
          title: "And which of these descriptions best describes your husband, wife, or partner's situation in the last 7 days? (Please select only one)"
          precondition:
            - predicate: has_partner_in_household == 1 and b45_multiple == 1
          input:
            control: Dropdown
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education, not paid for by employer"
              3: "Unemployed and actively looking for a job"
              4: "Unemployed, wanting a job but not actively looking"
              5: "Permanently sick or disabled"
              6: "Retired"
              7: "In community or military service"
              8: "Doing housework, looking after children or other persons"
              9: "Other"

        - id: q_b47
          kind: Question
          title: "Just to check, did your husband, wife, or partner do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: has_partner_in_household == 1 and partner_in_paid_work == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_b47.outcome == 1:
                partner_had_paid_work = 1

        - id: q_b48
          kind: Question
          title: "What is your husband, wife, or partner's main job?"
          precondition:
            - predicate: has_partner_in_household == 1 and (partner_in_paid_work == 1 or partner_had_paid_work == 1)
          input:
            control: Textarea
            placeholder: "Please describe their main job"
            maxLength: 300

        - id: q_b49
          kind: Question
          title: "What does your husband, wife, or partner mainly do in their job?"
          precondition:
            - predicate: has_partner_in_household == 1 and (partner_in_paid_work == 1 or partner_had_paid_work == 1)
          input:
            control: Textarea
            placeholder: "Please describe their main duties"
            maxLength: 300

        - id: q_b50
          kind: Question
          title: "What training or qualifications are needed for your husband, wife, or partner's job?"
          precondition:
            - predicate: has_partner_in_household == 1 and (partner_in_paid_work == 1 or partner_had_paid_work == 1)
          input:
            control: Textarea
            placeholder: "If no specific training or qualifications are needed, please write 'None'"
            maxLength: 300

        - id: q_b51
          kind: Question
          title: "In your husband, wife, or partner's main job are they..."
          precondition:
            - predicate: has_partner_in_household == 1 and (partner_in_paid_work == 1 or partner_had_paid_work == 1)
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for your own family's business"

        - id: q_b52
          kind: Question
          title: "How many hours does your husband, wife, or partner normally work a week in their main job? (Including any paid or unpaid overtime, 0-168)"
          precondition:
            - predicate: has_partner_in_household == 1 and (partner_in_paid_work == 1 or partner_had_paid_work == 1)
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"
          postcondition:
            - predicate: q_b52.outcome >= 0 and q_b52.outcome <= 168
              hint: "Please enter a number between 0 and 168 hours."

        - id: q_b53a
          kind: Question
          title: "What is the highest level of education your father completed? (Country-specific education level)"
          input:
            control: Dropdown
            labels:
              1: "Level 1 (lowest)"
              2: "Level 2"
              3: "Level 3"
              4: "Level 4"
              5: "Level 5"
              6: "Level 6"
              7: "Level 7"
              8: "Level 8"
              9: "Level 9"
              10: "Level 10"
              11: "Level 11"
              12: "Level 12"
              13: "Level 13"
              14: "Level 14"
              15: "Level 15"
              16: "Level 16"
              17: "Level 17"
              18: "Level 18"
              19: "Level 19"
              20: "Level 20"
              21: "Level 21"
              22: "Level 22"
              23: "Level 23"
              24: "Level 24 (highest)"

        - id: q_b54
          kind: Question
          title: "When you were 14, did your father work as an employee, was he self-employed, or was he not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Father deceased or absent when I was 14"
          codeBlock: |
            if q_b54.outcome == 1 or q_b54.outcome == 2:
                father_working = 1

        - id: q_b55
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your father did when you were 14?"
          precondition:
            - predicate: father_working == 1
          input:
            control: Radio
            labels:
              1: "Professional and technical occupations"
              2: "Higher administrator occupations"
              3: "Clerical occupations"
              4: "Sales occupations"
              5: "Service occupations"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"

        - id: q_b56a
          kind: Question
          title: "What is the highest level of education your mother completed? (Country-specific education level)"
          input:
            control: Dropdown
            labels:
              1: "Level 1 (lowest)"
              2: "Level 2"
              3: "Level 3"
              4: "Level 4"
              5: "Level 5"
              6: "Level 6"
              7: "Level 7"
              8: "Level 8"
              9: "Level 9"
              10: "Level 10"
              11: "Level 11"
              12: "Level 12"
              13: "Level 13"
              14: "Level 14"
              15: "Level 15"
              16: "Level 16"
              17: "Level 17"
              18: "Level 18"
              19: "Level 19"
              20: "Level 20"
              21: "Level 21"
              22: "Level 22"
              23: "Level 23"
              24: "Level 24 (highest)"

        - id: q_b57
          kind: Question
          title: "When you were 14, did your mother work as an employee, was she self-employed, or was she not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Mother deceased or absent when I was 14"
          codeBlock: |
            if q_b57.outcome == 1 or q_b57.outcome == 2:
                mother_working = 1

        - id: q_b58
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your mother did when you were 14?"
          precondition:
            - predicate: mother_working == 1
          input:
            control: Radio
            labels:
              1: "Professional and technical occupations"
              2: "Higher administrator occupations"
              3: "Clerical occupations"
              4: "Sales occupations"
              5: "Service occupations"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"

        - id: q_b59
          kind: Question
          title: "During the last twelve months, have you taken any course or attended any lecture or conference to improve your knowledge or skills for work?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_b60
          kind: Question
          title: "How would you describe your ancestry? (Please select up to two ancestries that best apply to you — Ancestry 1)"
          input:
            control: Textarea
            placeholder: "Please write in your first ancestry"
            maxLength: 200

        - id: q_b60b
          kind: Question
          title: "Ancestry 2 (if applicable — leave blank if you only have one ancestry)"
          input:
            control: Textarea
            placeholder: "Please write in your second ancestry, or leave blank"
            maxLength: 200

    # ───────────────────────────────────────────────────────────────
    # SECTION C — Subjective Well-being and Personal Values
    # ───────────────────────────────────────────────────────────────
    - id: b_section_c
      title: "Section C: Subjective Well-being"
      items:

        - id: q_c1
          kind: Question
          title: "To what extent do you agree or disagree with the following statement? I'm always optimistic about my future."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_c2
          kind: Question
          title: "How much of the time during the past week did you feel depressed?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c3
          kind: Question
          title: "How much of the time during the past week was your sleep restless?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c4
          kind: Question
          title: "How much of the time during the past week were you happy?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c5
          kind: Question
          title: "How much of the time during the past week did you feel lonely?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c6
          kind: Question
          title: "How much of the time during the past week did you enjoy life?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c7
          kind: Question
          title: "How much of the time during the past week did you feel sad?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c8
          kind: Question
          title: "How much of the time during the past week could you not get going?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c9
          kind: Question
          title: "How much of the time during the past week did you have a lot of energy?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c10
          kind: Question
          title: "How much of the time during the past week did you feel anxious?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c11
          kind: Question
          title: "How much of the time during the past week did you feel calm and peaceful?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

        - id: q_c12
          kind: Question
          title: "To what extent do you agree or disagree? In my daily life I get very little chance to show how capable I am."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_c13
          kind: Question
          title: "To what extent do you agree or disagree? I generally feel that what I do in my life is valuable and worthwhile."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_c14
          kind: Question
          title: "In your opinion, to what extent is there harmony among the people who live in your country? (0 = not at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_c15
          kind: Question
          title: "To what extent do you feel that people in your local area help one another? (0 = not at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_c16
          kind: Question
          title: "To what extent do you feel that people treat you with respect? (0 = not at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_c17
          kind: Question
          title: "On a typical day, how often do you take notice of and appreciate your surroundings? (0 = never, 10 = always)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Never"
            right: "Always"

        - id: q_c18
          kind: Question
          title: "To what extent do you feel that you have a sense of direction in your life? (0 = not at all, 10 = completely)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all"
            right: "Completely"

        - id: q_c19
          kind: Question
          title: "To what extent do you receive help and support from people you are close to when you need it? (0 = not at all, 6 = completely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        - id: q_c20
          kind: Question
          title: "And to what extent do you provide help and support to people you are close to when they need it? (0 = not at all, 6 = completely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        - id: q_c21
          kind: Question
          title: "To what extent are you doing the things you really want and value in your life? (0 = not at all, 6 = completely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        - id: q_c22
          kind: Question
          title: "To what extent are you able to achieve your goals? (0 = not at all, 6 = completely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        - id: q_c23
          kind: Question
          title: "To what extent do you feel safe and secure in your life nowadays? (0 = not at all, 6 = completely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        - id: q_c24
          kind: Question
          title: "Generally speaking, how close and connected do you feel to other people? (0 = not at all, 6 = extremely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Extremely"

        - id: q_c25
          kind: Question
          title: "How close and connected do you feel to the people in your local area? (0 = not at all, 6 = extremely)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Extremely"

        - id: q_c26
          kind: Question
          title: "To what extent do you agree or disagree? In difficult periods of my life, I can usually find something good that helps me change for the better."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_c27
          kind: Question
          title: "When you hear about an acquaintance going through a difficult time, how much compassion do you usually feel for them? (0 = none at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "None at all"
            right: "A great deal"

        - id: q_c28
          kind: Question
          title: "When you are going through a difficult time, to what extent do you give yourself the care and kindness you need? (0 = not at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_c29
          kind: Question
          title: "To what extent do you feel there is harmony in your life, that is, you feel balanced and at peace with yourself? (0 = not at all, 6 = a great deal)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_c30
          kind: Question
          title: "In difficult situations, how often do you manage to take a pause without immediately reacting? (0 = never, 6 = always)"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Never"
            right: "Always"

    # ─────────────────────────────────────────────────────────
    # SECTION D — Immigration and Global Attitudes
    # ─────────────────────────────────────────────────────────
    - id: b_section_d
      title: "Section D: Immigration and International Attitudes"
      items:

        - id: q_d1
          kind: Question
          title: "How important do you think it is that people in countries which are better off should help those in poorer countries who are unable to provide for their basic needs?"
          input:
            control: Radio
            labels:
              1: "Very important"
              2: "Important"
              3: "Not very important"
              4: "Not at all important"

        - id: q_d2
          kind: Question
          title: "How acceptable do you think it is that people ONLY help those who genuinely deserve assistance?"
          input:
            control: Radio
            labels:
              1: "Very acceptable"
              2: "Acceptable"
              3: "Not very acceptable"
              4: "Not at all acceptable"

        - id: q_d3
          kind: Question
          title: "Would you say that the world would be a better or a worse place if people from other countries were more like the people of your country?"
          input:
            control: Radio
            labels:
              1: "World would be a much better place"
              2: "World would be a better place"
              3: "Would not make it a better or worse place"
              4: "World would be a worse place"
              5: "World would be a much worse place"

        - id: q_d4
          kind: Question
          title: "How often should your country be ruthless in asserting its national interests against other countries?"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Hardly ever"
              5: "Never"

        - id: q_d5
          kind: Question
          title: "How important should it be for someone born, brought up and living outside your country to be able to come and live here: that they have good educational qualifications? (0 = extremely unimportant, 10 = extremely important)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        - id: q_d6
          kind: Question
          title: "How important should it be for them to be able to speak your country's official language(s)? (0 = extremely unimportant, 10 = extremely important)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        - id: q_d7
          kind: Question
          title: "How important should it be for them to come from a Christian background? (0 = extremely unimportant, 10 = extremely important)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        - id: q_d8
          kind: Question
          title: "How important should it be for them to be white? (0 = extremely unimportant, 10 = extremely important)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        - id: q_d9
          kind: Question
          title: "Would you say that people who come to live here generally take jobs away from workers in your country, or generally help to create new jobs? (0 = take jobs away, 10 = create new jobs)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Take jobs away"
            right: "Create new jobs"

        - id: q_d10
          kind: Question
          title: "Most people who come to live here work and pay taxes. They also use health and welfare services. On balance, do you think people who come here take out more than they put in or put in more than they take out? (0 = generally take out more, 10 = generally put in more)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Generally take out more"
            right: "Generally put in more"

        - id: q_d11
          kind: Question
          title: "Are your country's crime problems made worse or better by people coming to live here from other countries? (0 = crime problems made worse, 10 = crime problems made better)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Crime problems made worse"
            right: "Crime problems made better"

        - id: q_d12
          kind: Question
          title: "Now thinking of people who have come to live in your country from another country who are of a different race or ethnic group from most people in your country. How much would you mind or not mind if someone like this was appointed as your boss? (0 = not mind at all, 10 = mind a lot)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not mind at all"
            right: "Mind a lot"

        - id: q_d13
          kind: Question
          title: "Still thinking of people who have come to live in your country from another country who are of a different race or ethnic group. How much would you mind or not mind if someone like this married a close relative of yours? (0 = not mind at all, 10 = mind a lot)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not mind at all"
            right: "Mind a lot"

        - id: q_d14
          kind: Question
          title: "Your country has more than its fair share of people applying for refugee status."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_d15
          kind: Question
          title: "While their applications for refugee status are being considered, people should be allowed to work in your country."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_d16
          kind: Question
          title: "The government should be generous in judging people's applications for refugee status."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_d17
          kind: Question
          title: "While their cases are being considered, applicants should be kept in detention centres."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        - id: q_d18
          kind: Question
          title: "Out of every 100 people living in your country, how many do you think were born outside your country?"
          input:
            control: Editbox
            min: 0
            max: 100
          postcondition:
            - predicate: q_d18.outcome >= 0 and q_d18.outcome <= 100
              hint: "Please enter a number between 0 and 100."

        - id: q_d19
          kind: Question
          title: "Compared to people like yourself who were born in your country, how do you think the government treats those who have recently come to live here from other countries?"
          precondition:
            - predicate: born_in_country == 1
          input:
            control: Radio
            labels:
              1: "Much better"
              2: "A little better"
              3: "The same"
              4: "A little worse"
              5: "Much worse"

        - id: q_d20
          kind: Question
          title: "Do you think the religious beliefs and practices in your country are generally undermined or enriched by people coming to live here from other countries? (0 = undermined, 10 = enriched)"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Religious beliefs and practices undermined"
            right: "Religious beliefs and practices enriched"

        - id: q_d21
          kind: Question
          title: "Do you have any close friends who are of a different race or ethnic group from most people in your country?"
          input:
            control: Radio
            labels:
              1: "Yes, several"
              2: "Yes, a few"
              3: "No, none at all"

        - id: q_d22
          kind: Question
          title: "How often do you have any contact with people who are of a different race or ethnic group from most people in your country when you are out and about?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "Several times a month"
              5: "Once a week"
              6: "Several times a week"
              7: "Every day"

        - id: q_d23
          kind: Question
          title: "Thinking about this contact, in general how bad or good is it? (0 = extremely bad, 10 = extremely good)"
          precondition:
            - predicate: q_d22.outcome >= 2 and q_d22.outcome <= 7
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

        - id: q_d24
          kind: Question
          title: "Do you think some races or ethnic groups are born less intelligent than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        - id: q_d25
          kind: Question
          title: "Do you think some races or ethnic groups are born harder working than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        - id: q_d26
          kind: Question
          title: "Thinking about the world today, would you say that some cultures are much better than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        - id: q_d27
          kind: Question
          title: "Do you think that we should protect the culture of your country from the influence of other cultures?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        - id: q_d28
          kind: Question
          title: "To what extent do you think your country should allow Jewish people from other countries to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_d29
          kind: Question
          title: "To what extent do you think your country should allow Muslims from other countries to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        - id: q_d30
          kind: Question
          title: "To what extent do you think your country should allow people from a European country (who had to leave due to conflict or lack of work) to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

    # ─────────────────────────────────────
    # SECTION E — Human Values
    # ─────────────────────────────────────
    - id: b_section_e
      title: "Section E: Human Values"
      items:

        - id: q_e_intro
          kind: Comment
          title: "The following statements describe some people. Please indicate how much each person is or is not like you now."

        - id: q_e1
          kind: Question
          title: "It is important to this person to develop their own opinions."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e2
          kind: Question
          title: "It is important to this person that the state is strong and can defend its citizens."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e3
          kind: Question
          title: "It is important to this person to enjoy life's pleasures."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e4
          kind: Question
          title: "It is important to this person never to make other people angry."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e5
          kind: Question
          title: "It is important to this person to be very successful."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e6
          kind: Question
          title: "It is important to this person that everyone be treated justly, even people they don't know."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e7
          kind: Question
          title: "It is important to this person to have the power to make others comply with what they want."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e8
          kind: Question
          title: "It is important to this person to be humble."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e9
          kind: Question
          title: "It is important to this person to protect the natural environment from pollution or destruction."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e10
          kind: Question
          title: "It is important to this person never to be humiliated."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e11
          kind: Question
          title: "It is important to this person to have all sorts of new experiences."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e12
          kind: Question
          title: "It is important to this person to help the people close to them."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e13
          kind: Question
          title: "It is important to this person to be wealthy."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e14
          kind: Question
          title: "It is important to this person to be personally safe and secure."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e15
          kind: Question
          title: "It is important to this person to be tolerant towards all kinds of people and groups."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e16
          kind: Question
          title: "It is important to this person never to violate rules or regulations."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e17
          kind: Question
          title: "It is important to this person to make their own decisions about their life."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e18
          kind: Question
          title: "It is important to this person to follow traditions. These might be cultural, family or religious traditions."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e19
          kind: Question
          title: "It is important to this person that the people they know have full confidence in them."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

        - id: q_e20
          kind: Question
          title: "It is important to this person that their achievements are recognised by other people."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"

    # ─────────────────────────────────────────────────────────
    # SECTION F — Survey Experience (Self-completion modes)
    # ─────────────────────────────────────────────────────────
    - id: b_section_f
      title: "Section F: About This Survey"
      items:

        - id: q_f1
          kind: Question
          title: "Overall, how well did you feel you understood the questions?"
          input:
            control: Radio
            labels:
              1: "Understood only a few of the questions"
              2: "Understood some of the questions"
              3: "Understood most of the questions"
              4: "Understood all or nearly all of the questions"

        - id: q_f2
          kind: Question
          title: "Did you feel reluctant to answer any questions?"
          input:
            control: Radio
            labels:
              1: "None of the questions"
              2: "A few of the questions"
              3: "Some of the questions"
              4: "Most of the questions"
              5: "All or nearly all of the questions"

        - id: q_f3
          kind: Question
          title: "Did anyone else assist you in completing this questionnaire?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_f3.outcome == 1:
                assisted = 1

        - id: q_f4
          kind: Question
          title: "Who assisted you in completing the questionnaire? (Select all that apply)"
          precondition:
            - predicate: assisted == 1
          input:
            control: Checkbox
            labels:
              1: "Husband, wife, or partner"
              2: "Son or daughter"
              4: "Parent, parent-in-law, step-parent, or partner's parent"
              8: "Other relative"
              16: "Other non-relative"
              32: "The person who delivered the questionnaire"

        - id: q_f5
          kind: Question
          title: "What kind of assistance was given to you in completing the questionnaire? (Select all that apply)"
          precondition:
            - predicate: assisted == 1
          input:
            control: Checkbox
            labels:
              1: "Understanding the invitation letter and getting started"
              2: "Accessing the online survey"
              4: "Reading the questions aloud to me"
              8: "Providing information for questions about relatives or household members"
              16: "Helping me decide answers to other questions"
              32: "Returning my completed paper questionnaire"
              64: "Other"

        - id: q_f6
          kind: Question
          title: "Do you have any further comments on this survey or its questions?"
          input:
            control: Textarea
            placeholder: "Please write any comments here"
            maxLength: 1000

    # ──────────────────────────────────────────────────────────────────
    # SECTION G — Re-contact Consent
    # ──────────────────────────────────────────────────────────────────
    - id: b_section_g
      title: "Section G: Follow-up Study"
      items:

        - id: q_g1
          kind: Question
          title: "Would it be okay if we contact you again, to invite you to take part in a follow-up study?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_g1.outcome == 1:
                recontact = 1

        - id: q_g2_name
          kind: Question
          title: "Please enter your first name."
          precondition:
            - predicate: recontact == 1
          input:
            control: Textarea
            placeholder: "First name"
            maxLength: 100

        - id: q_g2_surname
          kind: Question
          title: "Please enter your surname."
          precondition:
            - predicate: recontact == 1
          input:
            control: Textarea
            placeholder: "Surname"
            maxLength: 100

        - id: q_g3_email
          kind: Question
          title: "Please enter your email address (if you have one)."
          precondition:
            - predicate: recontact == 1
          input:
            control: Textarea
            placeholder: "Email address"
            maxLength: 200

        - id: q_g5_phone
          kind: Question
          title: "Please enter your mobile telephone number (if you have one, including country code for international numbers)."
          precondition:
            - predicate: recontact == 1
          input:
            control: Textarea
            placeholder: "Mobile phone number"
            maxLength: 50
