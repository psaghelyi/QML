qmlVersion: "1.0"
questionnaire:
  title: "GSS Cycle 13 - Victimization Survey (1999)"
  codeInit: |
    # Section flags set by screening (Section A-K)
    spousal_abuse = 0
    ex_spousal_abuse = 0
    senior_child_abuse = 0
    senior_caregiver_abuse = 0
    has_spouse = 0
    has_ex_partner = 0
    respondent_age = 0
    respondent_sex = 0
    is_senior = 0
    marital_status = 0
    # Crime incident report tracking
    crime_incident_type = 0
    incident_in_12mo = 0
    incident_is_violent = 0
    incident_is_theft = 0
    incident_is_property = 0

  blocks:
    # =========================================================================
    # SECTION A: ENTRY / DEMOGRAPHICS (from household roster, pp.1-6)
    # =========================================================================
    - id: b_entry
      title: "Entry and Demographics"
      items:
        - id: a_sex
          kind: Question
          title: "Record sex of respondent."
          codeBlock: |
            respondent_sex = a_sex.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: a_age
          kind: Question
          title: "Can you tell me your age?"
          codeBlock: |
            respondent_age = a_age.outcome
            if respondent_age >= 65:
                is_senior = 1
            else:
                is_senior = 0
          input:
            control: Editbox
            min: 15
            max: 99

        - id: a_marital
          kind: Question
          title: "What is your marital status? Are you currently..."
          codeBlock: |
            marital_status = a_marital.outcome
            if a_marital.outcome in [1, 2]:
                has_spouse = 1
            else:
                has_spouse = 0
            if a_marital.outcome in [3, 4, 5]:
                has_ex_partner = 1
            else:
                has_ex_partner = 0
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Living common-law"
              3: "Separated"
              4: "Divorced"
              5: "Widowed"
              6: "Single (never married)"

    # =========================================================================
    # SECTION B: CRIME SCREENING (pp.7-17)
    # Eight crime-type screening questions
    # =========================================================================
    - id: b_screening
      title: "Crime Screening"
      items:
        - id: b1_theft_vehicle
          kind: Question
          title: "During the past 12 months, was any motor vehicle (car, truck, van, motorcycle, moped) or any part of a motor vehicle that belonged to you or your household stolen or was an attempt made to steal it?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b1a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b1_theft_vehicle.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b3_break_enter
          kind: Question
          title: "During the past 12 months, did anyone break into or enter your residence or any building on your property? Did anyone attempt to break into your residence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b3a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b3_break_enter.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b4_theft_property
          kind: Question
          title: "During the past 12 months (other than the incidents already mentioned), was any of your property stolen? (bicycle, electronic equipment, tools, clothing, money from outside the home, etc.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b4a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b4_theft_property.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b5_vandalism
          kind: Question
          title: "During the past 12 months, did anyone deliberately damage or destroy any of your property? (vandalism)"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b5a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b5_vandalism.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b8_sexual_assault
          kind: Question
          title: "During the past 12 months, has anyone forced you or attempted to force you into any unwanted sexual activity, by threatening you, holding you down or hurting you in some way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b8a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b8_sexual_assault.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b9_robbery
          kind: Question
          title: "During the past 12 months, has anyone taken or tried to take something from you by force or threat of force?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b9a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b9_robbery.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b10_physical_assault
          kind: Question
          title: "During the past 12 months, has anyone attacked you? (hit, slapped, grabbed, knocked down, or shot at)"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b10a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b10_physical_assault.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b11_threat
          kind: Question
          title: "During the past 12 months, has anyone threatened you with physical harm?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: b11a_num_incidents
          kind: Question
          title: "How many times did this happen during the past 12 months?"
          precondition:
            - predicate: b11_threat.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # SECTION C: PERCEPTIONS (pp.17-20)
    # =========================================================================
    - id: b_perceptions
      title: "Perceptions of Crime"
      items:
        - id: c1_safety_walk
          kind: Question
          title: "How safe do you feel walking alone in your area after dark? Would you say..."
          input:
            control: Radio
            labels:
              1: "Very safe"
              2: "Reasonably safe"
              3: "Somewhat unsafe"
              4: "Very unsafe"
              5: "Do not walk alone"

        - id: c2_safety_home
          kind: Question
          title: "How safe do you feel when you are home alone in the evening or at night?"
          input:
            control: Radio
            labels:
              1: "Very safe"
              2: "Reasonably safe"
              3: "Somewhat unsafe"
              4: "Very unsafe"

        - id: c3_safety_transit
          kind: Question
          title: "How safe do you feel using public transportation alone after dark?"
          input:
            control: Radio
            labels:
              1: "Very safe"
              2: "Reasonably safe"
              3: "Somewhat unsafe"
              4: "Very unsafe"
              5: "Do not use / not available"

        - id: c4_crime_neighbourhood
          kind: Question
          title: "Compared to other areas in Canada, would you say your neighbourhood has a higher amount of crime, about the same, or a lower amount of crime?"
          input:
            control: Radio
            labels:
              1: "Higher"
              2: "About the same"
              3: "Lower"

        - id: c5_crime_change
          kind: Question
          title: "During the past 5 years, do you think that crime in your neighbourhood has increased, decreased, or remained about the same?"
          input:
            control: Radio
            labels:
              1: "Increased"
              2: "Decreased"
              3: "About the same"

    # =========================================================================
    # SECTION D/E: SPOUSAL VIOLENCE SCREENING (pp.21-28)
    # Conditional on having a spouse/partner
    # =========================================================================
    - id: b_spousal_screen
      title: "Spousal Violence Screening"
      precondition:
        - predicate: has_spouse == 1
      items:
        - id: d1_intro
          kind: Comment
          title: "It is important to hear about experiences people may have in their relationships. I am going to read a list of statements and I would like you to tell me whether your spouse/partner has done any of the following to you."

        - id: d1_threatened
          kind: Question
          title: "During the past 5 years, has your spouse/partner threatened to hit you with his/her fist or anything else that could have hurt you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d2_thrown
          kind: Question
          title: "Has he/she thrown anything at you that could have hurt you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d3_pushed
          kind: Question
          title: "Has he/she pushed, grabbed or shoved you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d4_slapped
          kind: Question
          title: "Has he/she slapped you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d5_kicked
          kind: Question
          title: "Has he/she kicked, bit or hit you with his/her fist?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d6_hit_object
          kind: Question
          title: "Has he/she hit you with something that could have hurt you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d7_beaten
          kind: Question
          title: "Has he/she beaten you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d8_choked
          kind: Question
          title: "Has he/she choked you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d9_weapon
          kind: Question
          title: "Has he/she used or threatened to use a gun or knife on you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d10_sexual_force
          kind: Question
          title: "Has he/she forced you into any sexual activity when you did not want to by threatening you, holding you down, or hurting you in some way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: d11_any_violence
          kind: Question
          title: "Not counting the incidents already mentioned, during the past 5 years, has your partner done anything else to you that you considered to be violent or that frightened you?"
          codeBlock: |
            # PDF p.26 D11: if any of D1-D11 == 1, set spousal_abuse flag
            if d1_threatened.outcome == 1 or d2_thrown.outcome == 1 or d3_pushed.outcome == 1 or d4_slapped.outcome == 1 or d5_kicked.outcome == 1 or d6_hit_object.outcome == 1 or d7_beaten.outcome == 1 or d8_choked.outcome == 1 or d9_weapon.outcome == 1 or d10_sexual_force.outcome == 1 or d11_any_violence.outcome == 1:
                spousal_abuse = 1
            else:
                spousal_abuse = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # D12-D13: frequency and recency - only if any violence
        - id: d12_how_many_times
          kind: Question
          title: "How many different times did any of these things happen?"
          precondition:
            - predicate: spousal_abuse == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: d13_when_last
          kind: Question
          title: "When was the last time it happened? Was it within..."
          precondition:
            - predicate: spousal_abuse == 1
          input:
            control: Radio
            labels:
              1: "Past 12 months"
              2: "1 to 3 years ago"
              3: "3 to 5 years ago"

        - id: d14_on_path
          kind: Question
          title: "Did these incidents happen to you in total, or was each incident different?"
          precondition:
            - predicate: spousal_abuse == 1
          input:
            control: Radio
            labels:
              1: "One incident only"
              2: "Multiple different incidents"
              3: "One ongoing situation"

    # =========================================================================
    # SECTION E: EX-PARTNER SCREENING (pp.28-31) - parallel to D
    # =========================================================================
    - id: b_ex_partner_screen
      title: "Ex-Partner Violence Screening"
      precondition:
        - predicate: has_ex_partner == 1
      items:
        - id: f1_intro
          kind: Comment
          title: "Now I would like to ask you about contact with previous partners. During the past 5 years, did any of your former partners do any of the following to you?"

        - id: f1_threatened
          kind: Question
          title: "Threatened to hit you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f2_thrown
          kind: Question
          title: "Thrown anything at you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f3_pushed
          kind: Question
          title: "Pushed, grabbed or shoved you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f4_slapped
          kind: Question
          title: "Slapped you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f5_kicked
          kind: Question
          title: "Kicked, bit or hit you with fist?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f6_hit_object
          kind: Question
          title: "Hit you with something that could have hurt you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f7_beaten
          kind: Question
          title: "Beaten you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f8_choked
          kind: Question
          title: "Choked you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f9_weapon
          kind: Question
          title: "Used or threatened to use a gun or knife?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f10_sexual_force
          kind: Question
          title: "Forced you into any unwanted sexual activity?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f11_any_violence
          kind: Question
          title: "Done anything else you consider violent or frightening?"
          codeBlock: |
            if f1_threatened.outcome == 1 or f2_thrown.outcome == 1 or f3_pushed.outcome == 1 or f4_slapped.outcome == 1 or f5_kicked.outcome == 1 or f6_hit_object.outcome == 1 or f7_beaten.outcome == 1 or f8_choked.outcome == 1 or f9_weapon.outcome == 1 or f10_sexual_force.outcome == 1 or f11_any_violence.outcome == 1:
                ex_spousal_abuse = 1
            else:
                ex_spousal_abuse = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: f12_how_many_times
          kind: Question
          title: "How many different times did any of these things happen with your ex-partner?"
          precondition:
            - predicate: ex_spousal_abuse == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: f13_when_last
          kind: Question
          title: "When was the last time it happened?"
          precondition:
            - predicate: ex_spousal_abuse == 1
          input:
            control: Radio
            labels:
              1: "Past 12 months"
              2: "1 to 3 years ago"
              3: "3 to 5 years ago"

        - id: f14_on_path
          kind: Question
          title: "Did these incidents happen to you in total, or was each incident different?"
          precondition:
            - predicate: ex_spousal_abuse == 1
          input:
            control: Radio
            labels:
              1: "One incident only"
              2: "Multiple different incidents"
              3: "One ongoing situation"

    # =========================================================================
    # SECTION H/K: SENIOR ABUSE SCREENING (pp.33-38)
    # Only for respondents aged 65+
    # =========================================================================
    - id: b_senior_screen
      title: "Senior Abuse Screening"
      precondition:
        - predicate: is_senior == 1
      items:
        - id: h1_intro
          kind: Comment
          title: "The next few questions ask about some things that may have happened to you during the past 5 years. We are particularly interested in things that may have happened with people close to you, that is members of your family, friends, caregivers and others."

        # Child abuse sub-screening (H10-H13)
        - id: h10_child_violent
          kind: Question
          title: "During the past 5 years, has any of your children (including step-children and adopted children) been violent towards you? By this we mean anything from being pushed, grabbed, shoved, slapped, kicked, bit, hit, beaten, choked, burned, shot at, or attacked with a weapon."
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "No children"

        - id: h11_child_times
          kind: Question
          title: "How many different times did this happen in the past 5 years?"
          precondition:
            - predicate: h10_child_violent.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: h12_child_when
          kind: Question
          title: "When was the last time this happened?"
          precondition:
            - predicate: h10_child_violent.outcome == 1
          codeBlock: |
            if h10_child_violent.outcome == 1:
                senior_child_abuse = 1
          input:
            control: Radio
            labels:
              1: "Past 12 months"
              2: "1 to 3 years ago"
              3: "3 to 5 years ago"

        - id: h13_child_on_path
          kind: Question
          title: "On path or off path for child abuse report?"
          precondition:
            - predicate: h10_child_violent.outcome == 1
          input:
            control: Radio
            labels:
              1: "On path"
              2: "Off path"

        # Caregiver abuse sub-screening (K11-K14)
        - id: k11_caregiver_violent
          kind: Question
          title: "During the past 5 years, has any of your caregivers been violent towards you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "No caregiver"

        - id: k12_caregiver_times
          kind: Question
          title: "How many different times did this happen?"
          precondition:
            - predicate: k11_caregiver_violent.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: k13_caregiver_when
          kind: Question
          title: "When was the last time this happened?"
          precondition:
            - predicate: k11_caregiver_violent.outcome == 1
          codeBlock: |
            if k11_caregiver_violent.outcome == 1:
                senior_caregiver_abuse = 1
          input:
            control: Radio
            labels:
              1: "Past 12 months"
              2: "1 to 3 years ago"
              3: "3 to 5 years ago"

        - id: k14_caregiver_on_path
          kind: Question
          title: "On path or off path for caregiver abuse report?"
          precondition:
            - predicate: k11_caregiver_violent.outcome == 1
          input:
            control: Radio
            labels:
              1: "On path"
              2: "Off path"

    # =========================================================================
    # SECTION L: SPOUSAL ABUSE REPORT (pp.55-64)
    # PDF p.55: CATI-L0e: If SABUSE = (0), Go to M0.
    # =========================================================================
    - id: b_spousal_report
      title: "Spousal Abuse Report"
      precondition:
        - predicate: spousal_abuse == 1
      items:
        - id: l1_intro
          kind: Comment
          title: "You said that during the past 5 years, your spouse/partner was violent."

        - id: l2_injured
          kind: Question
          title: "During (these) this incident(s), were you (ever) physically injured in any way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.65 CATI-M2e complex routing: injury in 12 months check
        # Simplified: if injured AND recent, ask about 12-month injuries
        - id: l3_injured_12mo
          kind: Question
          title: "Did any of these incidents in which you were injured happen in the past 12 months?"
          precondition:
            - predicate: l2_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l4_hospital
          kind: Question
          title: "During the past 5 years, did you ever receive any medical attention at a hospital as a result of the violence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l4a_overnight
          kind: Question
          title: "Did you stay in hospital overnight?"
          precondition:
            - predicate: l4_hospital.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l4b_nights
          kind: Question
          title: "For how many nights?"
          precondition:
            - predicate: l4a_overnight.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: l5_medical
          kind: Question
          title: "During the past 5 years, did you ever receive any medical attention from a doctor or a nurse for your injuries?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l6_bed
          kind: Question
          title: "As a result of the violence, did you ever have to stay in bed for all or most of a day?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.55: L6=Yes -> L6A, L6=No/Refused -> Go to L7
        - id: l6a_days_bed
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: l6_bed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: l7_time_off
          kind: Question
          title: "Other than the time in hospital or bed, did you ever have to take time off from your everyday activities because of what happened?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l8_partner_drinking
          kind: Question
          title: "During (these) this incident(s) was your spouse/partner drinking?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Does not drink"

        - id: l12_others_harmed
          kind: Question
          title: "During the past 5 years, was anyone (else) ever harmed or threatened during (these) this incident(s)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.56: L12=Yes -> L12A, else Go to L14
        - id: l12a_how_many
          kind: Question
          title: "How many persons?"
          precondition:
            - predicate: l12_others_harmed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: l13_under15
          kind: Question
          title: "Were any of these people who were harmed or threatened under 15 years of age?"
          precondition:
            - predicate: l12_others_harmed.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l13a_under15_count
          kind: Question
          title: "How many persons?"
          precondition:
            - predicate: l13_under15.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: l14_children_witness
          kind: Question
          title: "Did any of your children see or hear (any of these) this incident(s)?"
          input:
            control: Radio
            labels:
              1: "Yes/think so"
              3: "No/don't think so"
              5: "No children at the time"

        - id: l15_fear_life
          kind: Question
          title: "During the past 5 years, did you ever fear that your life was in danger because of your spouse's/partner's violent or threatening behaviour?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l16_compensation
          kind: Question
          title: "During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.57: L16=Yes -> L16A, L16=No/Refused -> Go to L17
        - id: l16a_obtained
          kind: Question
          title: "Did you obtain any compensation?"
          precondition:
            - predicate: l16_compensation.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Not yet resolved"

        - id: l17_police
          kind: Question
          title: "Did the police ever find out about the violence in any way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.57: L17=Yes -> continue to L18, L17=No -> Go to L25A, DK/Refused -> Go to L27
        - id: l19_how_learned
          kind: Question
          title: "How did they learn about it? Was it from you or some other way?"
          precondition:
            - predicate: l17_police.outcome == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              3: "Some other way"

        # PDF p.57: L19=Respondent -> L20, L19=Other -> Go to L21
        - id: l20_reasons_reporting
          kind: QuestionGroup
          title: "People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported the violence?"
          precondition:
            - predicate: l17_police.outcome == 1 and l19_how_learned.outcome == 1
          questions:
            - "To stop the violence or receive protection?"
            - "To arrest and punish your spouse/partner?"
            - "Because you felt it was your duty to notify police?"
            - "On the recommendation of someone else?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: l22_satisfaction
          kind: Question
          title: "How satisfied were you with the actions that the police took?"
          precondition:
            - predicate: l17_police.outcome == 1
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"

        - id: l24_violence_change
          kind: Question
          title: "After the police were involved, did your spouse's/partner's violent or threatening behaviour towards you increase, decrease/stop, or stay the same?"
          precondition:
            - predicate: l17_police.outcome == 1 and d11_any_violence.outcome != 3
          input:
            control: Radio
            labels:
              1: "Increase"
              2: "Decrease/stop"
              3: "Stay the same"

        # PDF p.59: L25A-L25K: Reasons for NOT reporting (when L17=No)
        - id: l25a_dealt_other_way
          kind: Question
          title: "Because it was dealt with another way?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25b_fear_partner
          kind: Question
          title: "Because of fear of your spouse/partner?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25c_police_cant
          kind: Question
          title: "Because the police couldn't do anything about it?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25d_police_wont
          kind: Question
          title: "Because the police wouldn't help?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25e_no_police_involve
          kind: Question
          title: "Because you didn't want to get involved with police?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25x_no_arrest
          kind: Question
          title: "Because you didn't want your spouse/partner arrested or jailed?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25g_personal_matter
          kind: Question
          title: "Because the incident was a personal matter that didn't concern the police?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25y_no_find_out
          kind: Question
          title: "Because you didn't want anyone to find out about it?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25h_publicity
          kind: Question
          title: "Because of fear of publicity/news coverage?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l25f_not_important
          kind: Question
          title: "Because it was not important enough to you?"
          precondition:
            - predicate: l17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: l27_talked_to
          kind: QuestionGroup
          title: "(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as..."
          questions:
            - "Family?"
            - "Friend or neighbour?"
            - "Co-worker?"
            - "Doctor or nurse?"
            - "Lawyer?"
            - "Minister, priest, clergy or another spiritual advisor?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: l30_restorative_justice
          kind: Question
          title: "Thinking about your experience, how interested would you be in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Somewhat interested"
              3: "Slightly interested"
              4: "Not at all interested"

    # =========================================================================
    # SECTION M: EX-SPOUSAL ABUSE REPORT (pp.65-76)
    # PDF p.65: CATI-M0e: If EXABUSE = (0), Go to N0.
    # Near-identical to Section L but references ex-partner
    # =========================================================================
    - id: b_ex_spousal_report
      title: "Ex-Spousal Abuse Report"
      precondition:
        - predicate: ex_spousal_abuse == 1
      items:
        - id: m1_intro
          kind: Comment
          title: "You said that during the past 5 years your ex-partner was violent."

        - id: m2_injured
          kind: Question
          title: "During (these) this incident(s), were you (ever) physically injured in any way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m3_injured_12mo
          kind: Question
          title: "Did any of these incidents in which you were injured happen in the past 12 months?"
          precondition:
            - predicate: m2_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m4_hospital
          kind: Question
          title: "During the past 5 years, did you ever receive any medical attention at a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m4a_overnight
          kind: Question
          title: "Did you stay in hospital overnight?"
          precondition:
            - predicate: m4_hospital.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m4b_nights
          kind: Question
          title: "For how many nights?"
          precondition:
            - predicate: m4a_overnight.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: m5_medical
          kind: Question
          title: "Did you ever receive any medical attention from a doctor or nurse for your injuries?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m6_bed
          kind: Question
          title: "As a result of the violence, did you ever have to stay in bed for all or most of a day?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m6a_days_bed
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: m6_bed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: m7_time_off
          kind: Question
          title: "Did you ever have to take time off from everyday activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m8_ex_drinking
          kind: Question
          title: "During (these) this incident(s) was your ex-partner drinking?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Does not drink"

        - id: m15_fear_life
          kind: Question
          title: "Did you ever fear that your life was in danger because of your ex-partner's violent or threatening behaviour?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m17_police
          kind: Question
          title: "Did the police ever find out about the violence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # Reasons not reporting (M25A-K) - parallel to L25A-K
        - id: m25a_dealt_other
          kind: Question
          title: "Because it was dealt with another way?"
          precondition:
            - predicate: m17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m25b_fear_ex
          kind: Question
          title: "Because of fear of your ex-partner?"
          precondition:
            - predicate: m17_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: m30_restorative
          kind: Question
          title: "How interested would you be in participating in a restorative justice program?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Somewhat interested"
              3: "Slightly interested"
              4: "Not at all interested"

    # =========================================================================
    # SECTION N: SENIOR ABUSE BY CHILDREN REPORT (pp.77-88)
    # PDF p.77: CATI-N0e: If SCABUSE = (0), Go to P0.
    # =========================================================================
    - id: b_senior_child_report
      title: "Senior Abuse by Children Report"
      precondition:
        - predicate: senior_child_abuse == 1
      items:
        - id: n1_intro
          kind: Comment
          title: "You said that during the past 5 years, one of your children was violent."

        - id: n1a_which_child
          kind: Question
          title: "Was it a son or daughter who did this to you?"
          input:
            control: Radio
            labels:
              1: "Son(s)"
              2: "Daughter(s)"
              3: "Both"

        - id: n2_live_with
          kind: Question
          title: "At the time of the incident(s), did the child/children who did this to you live with you?"
          input:
            control: Radio
            labels:
              1: "Yes, during the whole period of abuse"
              2: "Yes, during some of the time of abuse"
              3: "No"

        - id: n3_injured
          kind: Question
          title: "During (these) this incident(s), were you (ever) physically injured?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.77: N3=No/Refused -> Go to N7
        - id: n4_injured_12mo
          kind: Question
          title: "Did any of these incidents in which you were injured happen in the past 12 months?"
          precondition:
            - predicate: n3_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n5_hospital
          kind: Question
          title: "Did you ever receive any medical attention at a hospital?"
          precondition:
            - predicate: n3_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n5a_overnight
          kind: Question
          title: "Did you stay in hospital overnight?"
          precondition:
            - predicate: n5_hospital.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n5b_nights
          kind: Question
          title: "For how many nights?"
          precondition:
            - predicate: n5a_overnight.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: n6_doctor
          kind: Question
          title: "Did you ever receive medical attention from a doctor or nurse?"
          precondition:
            - predicate: n3_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n7_bed
          kind: Question
          title: "As a result of the violence, did you ever have to stay in bed?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n7a_days
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: n7_bed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: n8_time_off
          kind: Question
          title: "Did you ever have to take time off from everyday activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n9_child_drinking
          kind: Question
          title: "During (these) this incident(s) was/were your child/children drinking?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Does not drink"

        - id: n12_fear_life
          kind: Question
          title: "Did you ever fear that your life was in danger?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n14_police
          kind: Question
          title: "Did the police ever find out about the violence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: n26_restorative
          kind: Question
          title: "How interested would you be in a restorative justice program?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Somewhat interested"
              3: "Slightly interested"
              4: "Not at all interested"

    # =========================================================================
    # SECTION P: SENIOR ABUSE BY CAREGIVER REPORT (pp.89-100)
    # PDF p.89: CATI-P0e: If SGABUSE = (0), Go to Q0.
    # =========================================================================
    - id: b_senior_caregiver_report
      title: "Senior Abuse by Caregiver Report"
      precondition:
        - predicate: senior_caregiver_abuse == 1
      items:
        - id: p1_intro
          kind: Comment
          title: "You said that during the past 5 years, your caregiver was violent."

        - id: p2_relationship
          kind: Question
          title: "What is/was your caregiver's relationship to you?"
          input:
            control: Dropdown
            labels:
              1: "Son-in-law"
              2: "Daughter-in-law"
              3: "Brother"
              4: "Sister"
              5: "Caregiver from an agency/organization"
              6: "Healthcare worker"
              7: "Friend/acquaintance"
              8: "Neighbour"
              9: "Other"

        - id: p3_injured
          kind: Question
          title: "During (these) this incident(s), were you (ever) physically injured?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: p5_hospital
          kind: Question
          title: "Did you receive medical attention at a hospital?"
          precondition:
            - predicate: p3_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: p7_bed
          kind: Question
          title: "Did you ever have to stay in bed?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: p9_caregiver_drinking
          kind: Question
          title: "Was your caregiver drinking during the incident(s)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Doesn't drink"

        - id: p12_fear_life
          kind: Question
          title: "Did you ever fear that your life was in danger?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: p14_police
          kind: Question
          title: "Did the police ever find out about the violence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: p26_restorative
          kind: Question
          title: "How interested would you be in a restorative justice program?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Somewhat interested"
              3: "Slightly interested"
              4: "Not at all interested"

    # =========================================================================
    # SECTION Q: CLASSIFICATION (pp.101-123)
    # Always asked - demographics and socioeconomic
    # =========================================================================
    - id: b_classification
      title: "Classification"
      items:
        - id: q1_dwelling
          kind: Question
          title: "In what type of dwelling are you now living?"
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double"
              3: "Garden house, town-house or row house"
              4: "Duplex"
              5: "Low-rise apartment (less than 5 stories)"
              6: "High-rise apartment (5 or more stories)"
              7: "Mobile home or trailer"
              8: "Other"

        - id: q2_owned
          kind: Question
          title: "Is this dwelling owned by a member of this household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: q2a_how_long
          kind: Question
          title: "How long have you lived in this dwelling?"
          input:
            control: Radio
            labels:
              1: "Less than six months"
              2: "6 months to less than 1 year"
              3: "1 year to less than 3 years"
              4: "3 years to less than 5 years"
              5: "5 years and over"

        - id: q5_born_canada
          kind: Question
          title: "In what country were you born?"
          input:
            control: Radio
            labels:
              1: "Canada"
              3: "Country outside Canada"

        - id: q6a_province
          kind: Question
          title: "In which province or territory?"
          precondition:
            - predicate: q5_born_canada.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Newfoundland/Labrador"
              2: "Prince Edward Island"
              3: "Nova Scotia"
              4: "New Brunswick"
              5: "Quebec"
              6: "Ontario"
              7: "Manitoba"
              8: "Saskatchewan"
              9: "Alberta"
              10: "British Columbia"
              11: "Yukon Territory"
              12: "Northwest Territories"
              13: "Nunavut"

        - id: q6b_country
          kind: Question
          title: "In which country?"
          precondition:
            - predicate: q5_born_canada.outcome == 3
          input:
            control: Dropdown
            labels:
              1: "China"
              2: "England"
              3: "France"
              4: "Germany"
              5: "Greece"
              6: "Guyana"
              7: "Hong Kong"
              8: "India"
              9: "Italy"
              10: "Jamaica"
              11: "Netherlands"
              12: "Philippines"
              13: "Poland"
              14: "Portugal"
              15: "Scotland"
              16: "United States"
              17: "Vietnam"
              18: "Other"

        # PDF p.109: Q10 only for married/common-law
        - id: q10_spouse_activity
          kind: Question
          title: "During the past 12 months, was your spouse/partner's main activity working at a paid job, looking for work, going to school, caring for children, household work, retired or something else?"
          precondition:
            - predicate: has_spouse == 1
          input:
            control: Dropdown
            labels:
              1: "Working at a paid job or business"
              2: "Looking for paid work"
              3: "Going to school"
              4: "Caring for children"
              5: "Household work"
              6: "Retired"
              7: "Maternity/paternity leave"
              8: "Long term illness"
              9: "Other"

        # PDF p.107: Q11 only if Q10=3 (going to school)
        - id: q11_spouse_student
          kind: Question
          title: "Was he/she studying full-time or part-time?"
          precondition:
            - predicate: has_spouse == 1 and q10_spouse_activity.outcome == 3
          input:
            control: Radio
            labels:
              1: "Full-time"
              3: "Part-time"

        # PDF p.107: Q12 if Q10 != 1 and Q10 != 3
        - id: q12_spouse_job
          kind: Question
          title: "Did he/she have a job or was he/she self-employed at any time during the past 12 months?"
          precondition:
            - predicate: has_spouse == 1 and q10_spouse_activity.outcome != 1 and q10_spouse_activity.outcome != 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.107: Q13 if Q10=1 or Q12=1
        - id: q13_spouse_weeks
          kind: Question
          title: "How many weeks did he/she work?"
          precondition:
            - predicate: has_spouse == 1 and (q10_spouse_activity.outcome == 1 or q12_spouse_job.outcome == 1)
          input:
            control: Editbox
            min: 1
            max: 52

        - id: q21a_education_years
          kind: Question
          title: "Excluding kindergarten, how many years of elementary and high school education have you successfully completed?"
          input:
            control: Dropdown
            labels:
              0: "No schooling"
              1: "One to five years"
              6: "Six years"
              7: "Seven years"
              8: "Eight years"
              9: "Nine years"
              10: "Ten years"
              11: "Eleven years"
              12: "Twelve years"
              13: "Thirteen years"

        # PDF p.109: Q21B only if Q21A >= 11
        - id: q21b_grad_hs
          kind: Question
          title: "Have you graduated from high school?"
          precondition:
            - predicate: q21a_education_years.outcome >= 11
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: q22_further_school
          kind: Question
          title: "Have you had any further schooling beyond elementary/high school?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: q23_highest_ed
          kind: Question
          title: "What is the highest level of education that you have attained?"
          precondition:
            - predicate: q22_further_school.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Masters or earned doctorate"
              2: "Degree in Medicine, Dentistry, etc."
              3: "Bachelor or undergraduate degree"
              4: "Diploma from community college, CEGEP"
              5: "Diploma from trade, technical or vocational school"
              6: "Some university"
              7: "Some community college, CEGEP"
              8: "Some trade, technical or vocational school"
              9: "Other"

        - id: q29a_difficulty
          kind: Question
          title: "Do you have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning, or doing any similar activities?"
          input:
            control: Radio
            labels:
              1: "Sometimes"
              2: "Often"
              3: "Never"

        - id: q29b_health_reduce
          kind: Question
          title: "Does a long term physical or mental condition or health problem reduce the amount or the kind of activity that you can do?"
          input:
            control: Radio
            labels:
              1: "Sometimes"
              2: "Often"
              3: "Never"

        - id: q29c_main_condition
          kind: Comment
          title: "What is the main condition or health problem that reduces your activities?"
          precondition:
            - predicate: q29b_health_reduce.outcome == 1 or q29b_health_reduce.outcome == 2

        - id: q30_sleep
          kind: Question
          title: "Do you regularly have trouble going to sleep or staying asleep?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: q31a_health
          kind: Question
          title: "Compared to other people your age, how would you describe your usual state of health?"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: q32_main_activity
          kind: Question
          title: "During the past 12 months, was your main activity working at a paid job or business, looking for paid work, going to school, caring for children, household work, retired or something else?"
          input:
            control: Dropdown
            labels:
              1: "Working at a paid job or business"
              2: "Looking for paid work"
              3: "Going to school"
              4: "Caring for children"
              5: "Household work"
              6: "Retired"
              7: "Maternity / paternity leave"
              8: "Long term illness"
              9: "Other"

        # PDF p.116: Q33 only if Q32=3
        - id: q33_student_ft
          kind: Question
          title: "Were you studying full-time or part-time?"
          precondition:
            - predicate: q32_main_activity.outcome == 3
          input:
            control: Radio
            labels:
              1: "Full time"
              3: "Part time"

        # PDF p.116: Q34 if Q32 != 1 and Q32 != 3
        - id: q34_had_job
          kind: Question
          title: "Did you have a job or were you self-employed at any time during the past 12 months?"
          precondition:
            - predicate: q32_main_activity.outcome != 1 and q32_main_activity.outcome != 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.116: Q36 if Q32=1 or Q34=1
        - id: q36_weeks_employed
          kind: Question
          title: "For how many weeks during the past 12 months were you employed?"
          precondition:
            - predicate: q32_main_activity.outcome == 1 or q34_had_job.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 52

        - id: q37_hours_week
          kind: Question
          title: "How many hours a week did you usually work at all jobs?"
          precondition:
            - predicate: q32_main_activity.outcome == 1 or q34_had_job.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168

        - id: q38_work_home
          kind: Question
          title: "Excluding overtime, do you usually work any of your scheduled hours at home?"
          precondition:
            - predicate: q32_main_activity.outcome == 1 or q34_had_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: q39_hours_home
          kind: Question
          title: "How many paid hours per week do you usually work at home?"
          precondition:
            - predicate: q38_work_home.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168

        - id: q44_work_schedule
          kind: Question
          title: "Which of the following best describes the hours you usually work at this job?"
          precondition:
            - predicate: q32_main_activity.outcome == 1 or q34_had_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "Regular daytime schedule or shift"
              2: "Regular evening shift"
              3: "Regular night shift"
              4: "Rotating shift"
              5: "Split shift"
              6: "On call or casual"
              7: "Irregular schedule"
              8: "Other"

        - id: q45_income_source
          kind: Question
          title: "What was your main source of income during the past 12 months?"
          input:
            control: Dropdown
            labels:
              0: "No income"
              1: "Employment or self-employment"
              2: "Employment insurance"
              3: "Worker's compensation"
              4: "Benefits from Canada or Quebec Pension Plan"
              5: "Retirement pensions, superannuation and annuities"
              6: "Basic Old Age Security"
              7: "Guaranteed Income Supplement or Spouse's Allowance"
              8: "Child Tax Benefit"
              9: "Provincial or municipal social assistance or welfare"
              10: "Child Support/Alimony"
              11: "Other Income"

        - id: q46_personal_income
          kind: Question
          title: "What is your best estimate of your total personal income, before deductions, FROM ALL SOURCES during the past 12 months?"
          input:
            control: Editbox
            min: 0
            max: 999999

        # PDF p.119: Q47 only if not one-person household
        - id: q47_other_earners
          kind: Question
          title: "Not including yourself, how many other household members received income from any source?"
          input:
            control: Editbox
            min: 0
            max: 15

        # PDF p.119-122: Q48A-K binary search for household income
        # CATI routing: complex branching based on Q46 value
        # The PDF routes Q47>0 respondents through a binary search tree
        # This is a FAITHFULLY REPRODUCED asymmetric routing from the PDF
        - id: q48a_hh_income_20k
          kind: Question
          title: "Was the total household income less than $20,000 or $20,000 and more?"
          precondition:
            - predicate: q47_other_earners.outcome > 0 and (q45_income_source.outcome == 0 or q46_personal_income.outcome == 0)
          input:
            control: Radio
            labels:
              1: "Less than $20,000"
              2: "$20,000 and more"

        - id: q48b_hh_income_10k
          kind: Question
          title: "Was the total household income less than $10,000 or $10,000 and more?"
          precondition:
            - predicate: q48a_hh_income_20k.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 and more"

        - id: q48c_hh_income_5k
          kind: Question
          title: "Was the total household income less than $5,000 or $5,000 and more?"
          precondition:
            - predicate: q48b_hh_income_10k.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $5,000"
              2: "$5,000 and more"

        - id: q48d_hh_income_15k
          kind: Question
          title: "Was it less than $15,000 or $15,000 and more?"
          precondition:
            - predicate: q48b_hh_income_10k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $15,000"
              2: "$15,000 and more"

        - id: q48e_hh_income_40k
          kind: Question
          title: "Was it less than $40,000 or $40,000 and more?"
          precondition:
            - predicate: q48a_hh_income_20k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $40,000"
              2: "$40,000 and more"

        - id: q48f_hh_income_30k
          kind: Question
          title: "Was it less than $30,000 or $30,000 and more?"
          precondition:
            - predicate: q48e_hh_income_40k.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $30,000"
              2: "$30,000 and more"

        - id: q48g_hh_income_50k
          kind: Question
          title: "Was it less than $50,000 or $50,000 and more?"
          precondition:
            - predicate: q48e_hh_income_40k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $50,000"
              2: "$50,000 and more"

        - id: q48h_hh_income_60k
          kind: Question
          title: "Was it less than $60,000 or $60,000 and more?"
          precondition:
            - predicate: q48g_hh_income_50k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $60,000"
              2: "$60,000 and more"

        - id: q48j_hh_income_80k
          kind: Question
          title: "Was it less than $80,000 or $80,000 and more?"
          precondition:
            - predicate: q48h_hh_income_60k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $80,000"
              2: "$80,000 and more"

        - id: q48k_hh_income_100k
          kind: Question
          title: "Was it less than $100,000 or $100,000 and more?"
          precondition:
            - predicate: q48j_hh_income_80k.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $100,000"
              2: "$100,000 and more"

        - id: q49_closing
          kind: Comment
          title: "I'd like to thank you very much for helping us out by completing this survey. On behalf of Statistics Canada I would like to thank you for your cooperation and wish you a good day."

    # =========================================================================
    # SECTION V: CRIME INCIDENT REPORT (pp.127-158)
    # Complex routing based on crime type (VSCRNO)
    # This section is entered once per crime incident reported in Section B
    # =========================================================================
    - id: b_incident_report
      title: "Crime Incident Report"
      precondition:
        - predicate: b1_theft_vehicle.outcome == 1 or b3_break_enter.outcome == 1 or b4_theft_property.outcome == 1 or b5_vandalism.outcome == 1 or b8_sexual_assault.outcome == 1 or b9_robbery.outcome == 1 or b10_physical_assault.outcome == 1 or b11_threat.outcome == 1
      items:
        - id: v1_month
          kind: Question
          title: "In what month did (this/the most recent) incident happen?"
          input:
            control: Dropdown
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"

        - id: v2_location
          kind: Question
          title: "Where did this incident take place?"
          codeBlock: |
            # Set flags for location-based routing
            if v2_location.outcome in [1, 2, 3, 4]:
                incident_at_home = 1
            else:
                incident_at_home = 0
          input:
            control: Dropdown
            labels:
              1: "Inside respondent's own home/apartment"
              2: "Inside a vacation property"
              3: "Inside garage or other building on respondent's property"
              4: "Outside respondent's home, apartment"
              5: "Offender's home (in or around)"
              6: "Other Private Residence or Farm"
              7: "In a restaurant or bar"
              8: "Inside school or on school grounds"
              9: "In a commercial or office building, factory, store, or shopping mall"
              10: "In a hospital, prison or rehabilitation centre"
              11: "On public transportation"
              12: "In a parking garage or parking lot"
              13: "On sidewalk/street/highway in respondent's neighbourhood"
              14: "On any other sidewalk/street/highway"
              15: "In a rural area or park"
              16: "Other"

        # PDF p.128 V3: only if V2=1 (own home)
        - id: v3_same_dwelling
          kind: Question
          title: "Was that the same dwelling that you are living in now?"
          precondition:
            - predicate: v2_location.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.128 V4: only if V3=No (different dwelling at time)
        - id: v4_dwelling_type
          kind: Question
          title: "What type of dwelling were you living in at the time of this incident?"
          precondition:
            - predicate: v2_location.outcome == 1 and v3_same_dwelling.outcome == 3
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double"
              3: "Garden house, town-house or row house"
              4: "Duplex"
              5: "Low-rise apartment"
              6: "High-rise apartment"
              7: "Mobile home or trailer"
              8: "Other"

        # PDF p.128 V5: if V2 in [1,3,4] or V3=Yes -> V5
        - id: v5_lived_with
          kind: Question
          title: "At the time of the incident, did the person(s) who committed the act live with you?"
          precondition:
            - predicate: v2_location.outcome in [1, 3, 4] or (v2_location.outcome == 1 and v3_same_dwelling.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.128 V6: only if V5=No (did not live with respondent)
        - id: v6_let_in
          kind: Question
          title: "Did someone let them in?"
          precondition:
            - predicate: v5_lived_with.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # PDF p.129 V7: only if V6=No
        - id: v7_get_in
          kind: Question
          title: "Did the person(s) who committed the act actually get in or just try to get in?"
          precondition:
            - predicate: v6_let_in.outcome == 3
          input:
            control: Radio
            labels:
              1: "Actually got in"
              3: "Tried to get in"
              5: "Threat received by telephone, mail, or e-mail"

        # PDF p.129 V8: if V7 != 5 (not telephone/mail threat)
        - id: v8_evidence
          kind: Question
          title: "Was there any evidence, such as a broken lock or window, that the person(s) forced/tried to force his/her way in?"
          precondition:
            - predicate: v7_get_in.outcome != 5
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # V10: weapon question - only for violent incidents
        # PDF CATI-V8e routes to V10 for physical attack, sexual assault, unwanted touching
        - id: v10_weapon
          kind: Question
          title: "Did the person(s) who committed the act have a weapon, such as a gun or knife or something he/she was using as a weapon?"
          precondition:
            - predicate: b8_sexual_assault.outcome == 1 or b9_robbery.outcome == 1 or b10_physical_assault.outcome == 1 or b11_threat.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v10a_weapon_type
          kind: Question
          title: "What type of weapon?"
          precondition:
            - predicate: v10_weapon.outcome == 1
          input:
            control: Radio
            labels:
              1: "Gun"
              2: "Knife"
              3: "Other"

        # V11: assault question
        - id: v11_assaulted
          kind: Question
          title: "In this incident, were you assaulted in any physical or sexual way?"
          precondition:
            - predicate: b8_sexual_assault.outcome == 1 or b9_robbery.outcome == 1 or b10_physical_assault.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # V12: threat question - if V9=No (not present) and not threat type
        - id: v12_threatened
          kind: Question
          title: "Did the person(s) threaten you with physical harm in any way?"
          precondition:
            - predicate: (b10_physical_assault.outcome == 1 or b9_robbery.outcome == 1) and v11_assaulted.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # V13: how threatened
        - id: v13_how_threatened
          kind: Question
          title: "How were you threatened? Was it face-to-face, by mail, by electronic mail, or over the telephone?"
          precondition:
            - predicate: b11_threat.outcome == 1 or v12_threatened.outcome == 1
          input:
            control: Radio
            labels:
              1: "Face-to-face"
              2: "By mail"
              3: "By electronic mail"
              4: "Over the telephone"
              5: "Other"

        - id: v14_threat_carried_out
          kind: Question
          title: "Did you think the threat was going to be carried out?"
          precondition:
            - predicate: b11_threat.outcome == 1 or v12_threatened.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # V16: injury for sexual assault/touching types
        - id: v16_injured
          kind: Question
          title: "Were you physically injured in any way?"
          precondition:
            - predicate: v11_assaulted.outcome == 1 or b8_sexual_assault.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v17_hospital
          kind: Question
          title: "Did you receive any medical attention at a hospital as a result of this incident?"
          precondition:
            - predicate: v16_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v17a_overnight
          kind: Question
          title: "Did you stay in hospital overnight?"
          precondition:
            - predicate: v17_hospital.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v17b_nights
          kind: Question
          title: "For how many nights?"
          precondition:
            - predicate: v17a_overnight.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 500

        - id: v18_doctor
          kind: Question
          title: "Did you receive any medical attention from a doctor or a nurse?"
          precondition:
            - predicate: v16_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v19_bed
          kind: Question
          title: "As a result of this incident, did you have to stay in bed for all or most of a day?"
          precondition:
            - predicate: v16_injured.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v19a_bed_days
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: v19_bed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 100

        - id: v20a_alcohol_related
          kind: Question
          title: "In your opinion, was this incident related to the person's alcohol or drug use?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v20b_own_alcohol
          kind: Question
          title: "Was this incident related to your own alcohol or drug use?"
          precondition:
            - predicate: b8_sexual_assault.outcome == 1 or b9_robbery.outcome == 1 or b10_physical_assault.outcome == 1 or b11_threat.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v21_one_person
          kind: Question
          title: "Was only one person involved in committing the act?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # Single offender details (V22-V24)
        - id: v22_sex
          kind: Question
          title: "Was the person male or female?"
          precondition:
            - predicate: v21_one_person.outcome == 1
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: v23_age
          kind: Question
          title: "How old would you say the person was?"
          precondition:
            - predicate: v21_one_person.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 95

        - id: v24_relationship
          kind: Question
          title: "What was the person's relationship to you?"
          precondition:
            - predicate: v21_one_person.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Mother"
              2: "Father"
              7: "Son"
              8: "Daughter"
              11: "Brother"
              12: "Sister"
              13: "Spouse/partner"
              14: "Ex-spouse/ex-partner"
              15: "Other family member"
              16: "Boyfriend/girlfriend"
              17: "Ex-boyfriend/ex-girlfriend"
              18: "Neighbour"
              19: "Friend/Casual acquaintance"
              20: "Co-worker"
              21: "Known by sight only"
              22: "Stranger"
              23: "Other"

        # Multiple offenders (V25-V29)
        - id: v25_how_many
          kind: Question
          title: "How many people were involved?"
          precondition:
            - predicate: v21_one_person.outcome == 3
          input:
            control: Editbox
            min: 2
            max: 95

        - id: v26_sex_group
          kind: Question
          title: "Were they male or female?"
          precondition:
            - predicate: v21_one_person.outcome == 3
          input:
            control: Radio
            labels:
              1: "All male"
              2: "All female"
              3: "Both male and female"

        # PDF p.136 V27: only if V26=3 (both)
        - id: v27_mostly
          kind: Question
          title: "Were they mostly male or mostly female?"
          precondition:
            - predicate: v26_sex_group.outcome == 3
          input:
            control: Radio
            labels:
              1: "Mostly male"
              2: "Mostly female"
              3: "Evenly divided"

        - id: v28_youngest_age
          kind: Question
          title: "How old would you say the youngest was?"
          precondition:
            - predicate: v21_one_person.outcome == 3
          input:
            control: Editbox
            min: 1
            max: 95

        - id: v29_oldest_age
          kind: Question
          title: "How old would you say the oldest was?"
          precondition:
            - predicate: v21_one_person.outcome == 3
          postcondition:
            - predicate: v29_oldest_age.outcome >= v28_youngest_age.outcome
              hint: "Oldest age must be >= youngest age"
          input:
            control: Editbox
            min: 1
            max: 95

        - id: v31_hate_crime
          kind: Question
          title: "Do you believe that this incident committed against you could be considered a hate crime? (motivated by hatred of person's sex, ethnicity, race, religion, sexual orientation, age, disability, culture or language)"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v32_hatred_of
          kind: Question
          title: "Was this because of the person's hatred of your..."
          precondition:
            - predicate: v31_hate_crime.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Sex"
              2: "Race/Ethnicity"
              3: "Religion"
              4: "Sexual Orientation"
              5: "Age"
              6: "Disability"
              7: "Culture"
              8: "Language"
              9: "Other"

        - id: v33_others_harmed
          kind: Question
          title: "Was anyone (else) harmed or threatened during this incident?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v33a_how_many
          kind: Question
          title: "How many people?"
          precondition:
            - predicate: v33_others_harmed.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 95

        - id: v34_under15
          kind: Question
          title: "Were any of these people under 15 years of age?"
          precondition:
            - predicate: v33_others_harmed.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v34a_under15_count
          kind: Question
          title: "How many people?"
          precondition:
            - predicate: v34_under15.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 95

        # Theft section (V35-V38)
        - id: v35_stolen
          kind: Question
          title: "Was anything that belonged to you or your household stolen during this incident?"
          precondition:
            - predicate: b1_theft_vehicle.outcome == 1 or b3_break_enter.outcome == 1 or b4_theft_property.outcome == 1 or b9_robbery.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v37_stolen_value
          kind: Question
          title: "What is your estimate of the value of all property and cash stolen in this incident?"
          precondition:
            - predicate: v35_stolen.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v38_recovered
          kind: Question
          title: "Was any of the stolen money and/or property recovered, not counting anything received from insurance?"
          precondition:
            - predicate: v35_stolen.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v38a_all_recovered
          kind: Question
          title: "Was it all recovered?"
          precondition:
            - predicate: v38_recovered.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # Attempted theft (V39-V40)
        - id: v39_attempted_theft
          kind: Question
          title: "Did this person ATTEMPT to take anything that belonged to you or your household?"
          precondition:
            - predicate: (b1_theft_vehicle.outcome == 1 or b4_theft_property.outcome == 1) and v35_stolen.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # Damage section (V41-V45)
        - id: v41_damaged
          kind: Question
          title: "Was anything that belonged to you or a member of your household damaged but not taken in this incident?"
          precondition:
            - predicate: b5_vandalism.outcome == 1 or b3_break_enter.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v43_damage_value
          kind: Question
          title: "What is your estimate of the value of all damage done in this incident?"
          precondition:
            - predicate: v41_damaged.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # Insurance and compensation (V46-V49)
        - id: v46_insurance
          kind: Question
          title: "At the time of the incident, did you have any insurance?"
          precondition:
            - predicate: v35_stolen.outcome == 1 or v41_damaged.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v47_claim_insurance
          kind: Question
          title: "Did you attempt to obtain compensation for this incident through an insurance company?"
          precondition:
            - predicate: v46_insurance.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v47a_obtained
          kind: Question
          title: "Did you obtain any compensation?"
          precondition:
            - predicate: v47_claim_insurance.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Not yet resolved"

        - id: v48_court_compensation
          kind: Question
          title: "Did you attempt to obtain compensation through a civil or criminal court or a provincial compensation program?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v48a_obtained_court
          kind: Question
          title: "Did you obtain any compensation?"
          precondition:
            - predicate: v48_court_compensation.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Not yet resolved"

        - id: v49_expenses
          kind: Question
          title: "For this incident, what is your estimate of your out-of-pocket expenses, that is, expenses for which you do not expect to be reimbursed?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v50_main_activity
          kind: Question
          title: "Which of the following best describes your main activity during the week of the incident?"
          input:
            control: Radio
            labels:
              1: "On holiday"
              2: "Working at a paid job or business"
              3: "Looking for work"
              4: "A student"
              5: "Caring for children"
              6: "Household work"
              7: "Retired"
              8: "Maternity/paternity leave"
              9: "Long term illness"
              10: "Other"

        # V51: disruption - PDF p.144: only if V50 not in [7,8,9]
        - id: v51_disrupted
          kind: Question
          title: "As a result of this incident, did you find it difficult or impossible to carry out your main activity for all or most of a day?"
          precondition:
            - predicate: v50_main_activity.outcome != 7 and v50_main_activity.outcome != 8 and v50_main_activity.outcome != 9
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v51a_days
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: v51_disrupted.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999

        # Police reporting (V52-V59)
        - id: v52_police
          kind: Question
          title: "Did the police find out about this incident in any way?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v53_how_learned
          kind: Question
          title: "How did they learn about it? Was it from you or some other way?"
          precondition:
            - predicate: v52_police.outcome == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              3: "Some other way"

        - id: v54_reasons_reporting
          kind: QuestionGroup
          title: "People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident?"
          precondition:
            - predicate: v52_police.outcome == 1 and v53_how_learned.outcome == 1
          questions:
            - "To stop the incident or receive protection?"
            - "To catch and punish the offender?"
            - "To file a report to claim compensation or insurance?"
            - "Because you felt it was your duty to notify police?"
            - "On the recommendation of someone else?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: v55_police_action
          kind: Question
          title: "What action did the police take? (primary action)"
          precondition:
            - predicate: v52_police.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Visited Scene"
              2: "Made a report/Conducted an investigation"
              3: "Gave warning to offender"
              4: "Took offender away"
              5: "Made arrest/Laid charges"
              6: "Put you in touch with community services"
              7: "Other"
              8: "None"

        - id: v56_satisfaction
          kind: Question
          title: "How satisfied were you with the actions that the police took?"
          precondition:
            - predicate: v52_police.outcome == 1
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"

        # Reasons for NOT reporting (V58A-K) when V52=No
        - id: v58a_dealt_other
          kind: Question
          title: "Because it was dealt with another way?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58b_fear_revenge
          kind: Question
          title: "Because of fear of revenge by the offender?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58c_police_cant
          kind: Question
          title: "Because the police couldn't do anything about it?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58d_police_wont
          kind: Question
          title: "Because the police wouldn't help?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58e_no_police_involve
          kind: Question
          title: "Because you did not want to get involved with police?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58f_not_important
          kind: Question
          title: "Because it was not important enough to you?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58g_personal_matter
          kind: Question
          title: "Because the incident was a personal matter and did not concern the police?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v58h_publicity
          kind: Question
          title: "Because of fear of publicity/news coverage?"
          precondition:
            - predicate: v52_police.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # Talked to anyone (V60)
        - id: v60_talked_to
          kind: QuestionGroup
          title: "(Other than to the police,) did you ever talk to anyone about what happened, such as..."
          questions:
            - "Family?"
            - "Friend or neighbour?"
            - "Co-worker?"
            - "Doctor or nurse?"
            - "Lawyer?"
            - "Minister, priest, clergy, or another spiritual advisor?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: v62_victim_services
          kind: Question
          title: "Did you ever contact or use police-based or court-based victim services because of this incident?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        - id: v63_restorative
          kind: Question
          title: "How interested would you be in participating in a restorative justice program?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Somewhat interested"
              3: "Slightly interested"
              4: "Not at all interested"

        - id: v64_emotional_impact
          kind: Question
          title: "At the time of the incident, how did this experience affect you? (select primary impact)"
          input:
            control: Dropdown
            labels:
              1: "Afraid for children"
              2: "Angry"
              3: "Ashamed/guilty"
              4: "Depression/anxiety attacks"
              5: "Fearful"
              6: "Hurt/disappointment"
              7: "Increased self-reliance"
              8: "Lowered self esteem"
              9: "More cautious/aware"
              10: "Not much"
              11: "Problems relating to men/women"
              12: "Shock/disbelief"
              13: "Sleeping problems"
              14: "Upset/confused/frustrated"
              15: "Other"
