qmlVersion: "1.0"
questionnaire:
  title: "ICS Kérdezési Protokoll v2.0 - Sürgősségi Orvosi Diszpécser Triázs Protokoll"
  codeInit: |
    age_group = 0
    event_type = 0
    priority = 0
    route_breathing = 0
    route_neuro = 0
    route_stroke = 0
    route_pain = 0
    route_injury = 0
    route_allergy = 0
    route_fever = 0
    route_psychiatry = 0
    route_pregnancy = 0
    pain_type = 0
    injury_type = 0
    route_condition_overview = 0
    danger_present = 0
    alarming = 0
    is_severe_accident = 0
    num_injured = 0
    acc_bleeding = 0
    abcde_no_response = 0
    abcde_strange_voice = 0
    abcde_breathing_diff = 0
    abcde_unusual_skin = 0
    abcde_sweating = 0
    abcde_behavior = 0
    abcde_seizure = 0
    abcde_arm_weakness = 0
    abcde_face_asymmetry = 0
    abcde_speech_changed = 0
    abcde_pain = 0
    abcde_injury = 0
    abcde_routed = 0
    bd_choking_object = 0
    bd_throat_swollen = 0
    bd_anafilaxia = 0
    neuro_onset = 0
    neuro_fast_positive = 0
    neuro_fever = 0
    neuro_head_injury = 0
    neuro_other_pain = 0
    stroke_onset_lt24h = 0
    head_injury_redirect = 0
    chest_injury_redirect = 0
    abdo_injury_redirect = 0
    spine_injury_redirect = 0
    limb_injury_redirect = 0
    abdo_pregnancy_redirect = 0
    other_pain_injury_redirect = 0
    allergy_severe = 0
    allergy_mild = 0
    preg_visible_part = 0
    preg_imminent_birth = 0
    fever_age_cat = 0
    bp_available = 0
    bp_level = 0
    onset = 0
    severity = 0
    has_syncope = 0
    has_nausea = 0
    bd_neuro_route = 0
    bd_stroke_route = 0
    bd_pain_route = 0
    bd_injury_route = 0
    route_airway = 0
    route_seizure = 0
    mass_casualty = 0
    cut_down = 0
    power_off = 0
    rescued = 0

  blocks:
    # =========================================================================
    # B_INITIAL - Hívásfogadás (Call Reception) - P1
    # =========================================================================
    - id: b_initial
      title: "Hívásfogadás"
      items:
        - id: q_p1_01
          kind: Question
          title: "Riasztó tünet vagy esemény áll fenn?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            alarming = q_p1_01.outcome

        - id: q_p1_02
          kind: Question
          title: "Lát-e nyilvánvaló veszélyt a helyszínen?"
          precondition:
            - predicate: alarming == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            danger_present = q_p1_02.outcome

        - id: q_p1_03
          kind: Question
          title: "Megszűnt a veszély? (Biztonságos-e a helyszín?)"
          precondition:
            - predicate: danger_present == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_p1_04
          kind: Question
          title: "Mi az esemény típusa?"
          precondition:
            - predicate: alarming == 1
          input:
            control: Radio
            labels:
              1: "Baleset"
              2: "Akasztás"
              3: "Áramütés"
              4: "Vízbefulladás"
              5: "Egyik sem (betegség/egyéb)"
          codeBlock: |
            if q_p1_04.outcome == 1:
                event_type = 1
            if q_p1_04.outcome == 2:
                event_type = 2
            if q_p1_04.outcome == 3:
                event_type = 3
            if q_p1_04.outcome == 4:
                event_type = 4
            if q_p1_04.outcome == 5:
                event_type = 5

        - id: q_p1_05
          kind: Question
          title: "A beteg kora?"
          precondition:
            - predicate: alarming == 1
          input:
            control: Radio
            labels:
              1: "Felnőtt (18 év felett)"
              2: "Gyerek (1-18 év)"
              3: "Csecsemő (1 év alatt)"
          codeBlock: |
            age_group = q_p1_05.outcome

    # =========================================================================
    # B_ACCIDENT - Baleset (Accident) - P24
    # =========================================================================
    - id: b_accident
      title: "Baleset"
      precondition:
        - predicate: event_type == 1
      items:
        - id: q_acc_01
          kind: Question
          title: "Súlyos baleset történt? (Pl. nagy energiájú ütközés, zuhanás nagy magasságból, gázolás)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            is_severe_accident = q_acc_01.outcome
            if is_severe_accident == 1:
                priority = 1

        - id: q_acc_02
          kind: Question
          title: "Hány sérült van?"
          input:
            control: Radio
            labels:
              1: "1 sérült"
              2: "2-3 sérült"
              3: "4 vagy több sérült"
          codeBlock: |
            num_injured = q_acc_02.outcome
            if q_acc_02.outcome == 3:
                mass_casualty = 1

        - id: q_acc_03
          kind: Question
          title: "Van-e vérzés?"
          input:
            control: Radio
            labels:
              1: "Nincs vagy enyhe vérzés"
              2: "Mérsékelt vérzés"
              3: "Súlyos, csillapíthatatlan vérzés"
          codeBlock: |
            acc_bleeding = q_acc_03.outcome
            if q_acc_03.outcome == 3:
                priority = 1
            if q_acc_03.outcome == 2:
                if priority == 0:
                    priority = 2

    # =========================================================================
    # B_MASS_CASUALTY - Több sérültes eset (Mass Casualty) - P25
    # =========================================================================
    - id: b_mass_casualty
      title: "Tömeges baleset"
      precondition:
        - predicate: event_type == 1
        - predicate: mass_casualty == 1
      items:
        - id: q_mass_01
          kind: Question
          title: "Meg tudja számolni a sérülteket?"
          input:
            control: Radio
            labels:
              1: "4 vagy több sérült"
              2: "2-3 sérült"
          codeBlock: |
            if q_mass_01.outcome == 1:
                priority = 1

        - id: q_mass_02
          kind: Question
          title: "Van-e gyermek a sérültek között?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_mass_03
          kind: Question
          title: "Van-e mozdulatlan sérült?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_mass_03.outcome == 1:
                priority = 1

        - id: q_mass_04
          kind: Question
          title: "Van-e beszorult sérült?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_mass_04.outcome == 1:
                priority = 1

        - id: q_mass_05
          kind: Question
          title: "Van-e vérzés a sérülteknél?"
          input:
            control: Radio
            labels:
              1: "Nincs vagy enyhe vérzés"
              2: "Mérsékelt vérzés"
              3: "Súlyos, csillapíthatatlan vérzés"
          codeBlock: |
            if q_mass_05.outcome == 3:
                priority = 1

    # =========================================================================
    # B_HANGING - Akasztás (Hanging) - P41
    # =========================================================================
    - id: b_hanging
      title: "Akasztás"
      precondition:
        - predicate: event_type == 2
      items:
        - id: q_hang_01
          kind: Question
          title: "Levágták/leakasztották már?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            cut_down = q_hang_01.outcome
            priority = 1

    # =========================================================================
    # B_ELECTROCUTION - Áramütés (Electrocution) - P42
    # =========================================================================
    - id: b_electrocution
      title: "Áramütés"
      precondition:
        - predicate: event_type == 3
      items:
        - id: q_elec_01
          kind: Question
          title: "Milyen áramforrás okozta?"
          input:
            control: Radio
            labels:
              1: "Ipari áram (nagyfeszültség)"
              2: "Háztartási áram"
              3: "Ismeretlen"
          codeBlock: |
            if q_elec_01.outcome == 1:
                priority = 1
            if q_elec_01.outcome == 2:
                priority = 2
            if q_elec_01.outcome == 3:
                priority = 1

        - id: q_elec_02
          kind: Question
          title: "Áramtalanítva van-e a helyszín?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            power_off = q_elec_02.outcome

    # =========================================================================
    # B_DROWNING - Vízbefulladás (Drowning) - P43
    # =========================================================================
    - id: b_drowning
      title: "Vízbefulladás"
      precondition:
        - predicate: event_type == 4
      items:
        - id: q_drown_01
          kind: Question
          title: "Kihúzták már a vízből?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            rescued = q_drown_01.outcome
            priority = 1

    # =========================================================================
    # B_ABCDE - ABCDE Elsődleges Vizsgálat (Primary Assessment) - P2/44/52
    # =========================================================================
    - id: b_abcde
      title: "ABCDE Elsődleges Vizsgálat"
      precondition:
        - predicate: alarming == 1
      items:
        # --- A: Airway / Responsiveness ---
        - id: q_abcde_01
          kind: Question
          title: "Tud beszélni / sír / gügyög a beteg?"
          input:
            control: Radio
            labels:
              1: "Beszél / reagál (érthető válasz)"
              2: "Reagál, de nem érthető"
              3: "Nem reagál"
          codeBlock: |
            if q_abcde_01.outcome == 3:
                abcde_no_response = 1
                priority = 1
                abcde_routed = 1

        # --- A: Voice quality (waterfall: only if responsive) ---
        - id: q_abcde_02
          kind: Question
          title: "Furcsa hangot hall? (Rekedtség, sípolás, hörgés, bugyborékolás?)"
          precondition:
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_strange_voice = q_abcde_02.outcome

        - id: q_abcde_03
          kind: Question
          title: "Milyen típusú furcsa hangot hall?"
          precondition:
            - predicate: abcde_strange_voice == 1
          input:
            control: Radio
            labels:
              1: "Rekedt hang"
              2: "Zajos légzés / stridor"
              3: "Sípoló légzés / wheezing"
              4: "Bugyborékoló / gurgulázó hang"
              5: "Egyéb furcsa hang"
          codeBlock: |
            route_breathing = 1
            abcde_routed = 1

        # --- B: Breathing difficulty ---
        - id: q_abcde_04
          kind: Question
          title: "Fullad vagy nehezen lélegzik a beteg?"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_breathing_diff = q_abcde_04.outcome
            if abcde_breathing_diff == 1:
                route_breathing = 1
                abcde_routed = 1

        # --- C: Skin appearance ---
        - id: q_abcde_05
          kind: Question
          title: "Szokatlan-e a bőre? (Sápadt, kékes, hideg, kipirult?)"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_unusual_skin = q_abcde_05.outcome

        - id: q_abcde_06
          kind: Question
          title: "Milyen a bőr megjelenése?"
          precondition:
            - predicate: abcde_unusual_skin == 1
            - predicate: abcde_routed == 0
          input:
            control: Radio
            labels:
              1: "Sápadt"
              2: "Kékes / lila (cianózis)"
              3: "Hideg, nyirkos"
              4: "Kipirult, piros"
          codeBlock: |
            route_allergy = 1
            abcde_routed = 1

        # --- C: Sweating ---
        - id: q_abcde_07
          kind: Question
          title: "Verejtékezik a beteg?"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_sweating = q_abcde_07.outcome

        # --- D: Behavior change ---
        - id: q_abcde_08
          kind: Question
          title: "Megváltozott a viselkedése? (Zavart, nyugtalan, aluszékony?)"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_behavior = q_abcde_08.outcome
            if abcde_behavior == 1:
                route_neuro = 1
                abcde_routed = 1

        # --- D: Seizures ---
        - id: q_abcde_09
          kind: Question
          title: "Görcsöl a beteg?"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_seizure = q_abcde_09.outcome
            if abcde_seizure == 1:
                route_seizure = 1
                abcde_routed = 1
                priority = 1

        # --- D: FAST - Arm weakness ---
        - id: q_abcde_10
          kind: Question
          title: "Van-e kar gyengeség? (Kérje meg, hogy emelje fel mindkét karját!)"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_arm_weakness = q_abcde_10.outcome
            if abcde_arm_weakness == 1:
                route_stroke = 1
                abcde_routed = 1

        # --- D: FAST - Facial asymmetry ---
        - id: q_abcde_11
          kind: Question
          title: "Van-e arc aszimmetria? (Lóg-e az egyik arcfele?)"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_face_asymmetry = q_abcde_11.outcome
            if abcde_face_asymmetry == 1:
                route_stroke = 1
                abcde_routed = 1

        # --- D: FAST - Speech changed ---
        - id: q_abcde_12
          kind: Question
          title: "Megváltozott-e a beszéde? (Elhúzott, érthetetlen, összefüggéstelen?)"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_speech_changed = q_abcde_12.outcome
            if abcde_speech_changed == 1:
                route_stroke = 1
                abcde_routed = 1

        # --- E: Pain ---
        - id: q_abcde_13
          kind: Question
          title: "Van-e fájdalma a betegnek?"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_pain = q_abcde_13.outcome
            if abcde_pain == 1:
                route_pain = 1
                abcde_routed = 1

        # --- E: Injury ---
        - id: q_abcde_14
          kind: Question
          title: "Van-e sérülése a betegnek?"
          precondition:
            - predicate: abcde_routed == 0
            - predicate: abcde_no_response == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abcde_injury = q_abcde_14.outcome
            if abcde_injury == 1:
                route_injury = 1
                abcde_routed = 1
            if abcde_injury == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_BREATHING - Nehézlégzés I+II (Breathing Difficulty) - P9-10/49-50/57-58
    # =========================================================================
    - id: b_breathing
      title: "Nehézlégzés"
      precondition:
        - predicate: route_breathing == 1
      items:
        # --- Breathing Difficulty I ---
        - id: q_bd1_01
          kind: Question
          title: "Fullad a beteg? (Nem kap levegőt?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd1_01.outcome == 1:
                priority = 1

        - id: q_bd1_02
          kind: Question
          title: "Félrenyelhetett? (Ételt vagy tárgyat nyelt el?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            bd_choking_object = q_bd1_02.outcome
            if bd_choking_object == 1:
                route_airway = 1

        - id: q_bd1_03
          kind: Question
          title: "Dagad a torka?"
          precondition:
            - predicate: bd_choking_object == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            bd_throat_swollen = q_bd1_03.outcome
            if bd_throat_swollen == 1:
                route_allergy = 1
                allergy_severe = 1

        - id: q_bd1_04
          kind: Question
          title: "Tud folyamatosan beszélni?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
          input:
            control: Radio
            labels:
              1: "Nem tud beszélni"
              2: "Csak szavakat mond"
              3: "Rövid mondatokat mond"
              4: "Teljes mondatokat mond"
          codeBlock: |
            if q_bd1_04.outcome == 1:
                priority = 1
            if q_bd1_04.outcome == 2:
                priority = 1
            if q_bd1_04.outcome == 3:
                if priority == 0:
                    priority = 2

        - id: q_bd1_05
          kind: Question
          title: "Milyen a légzési munka?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
          input:
            control: Radio
            labels:
              1: "Kimerült / súlyos (behúzódások, segédizmok)"
              2: "Mérsékelt"
              3: "Enyhe"
          codeBlock: |
            if q_bd1_05.outcome == 1:
                priority = 1
            if q_bd1_05.outcome == 2:
                if priority == 0:
                    priority = 2

        - id: q_bd1_06
          kind: Question
          title: "SpO2 (pulzoximetria) mérhető-e?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_bd1_07
          kind: Question
          title: "Mennyi a SpO2 értéke?"
          precondition:
            - predicate: q_bd1_06.outcome == 1
          input:
            control: Radio
            labels:
              1: "90% alatt"
              2: "90-92%"
              3: "92-94%"
              4: "94% felett"
          codeBlock: |
            if q_bd1_07.outcome == 1:
                priority = 1
            if q_bd1_07.outcome == 2:
                if priority == 0:
                    priority = 2

        - id: q_bd1_08
          kind: Question
          title: "Szokatlan a bőre? (Sápadt, kékes, kipirult?) - ANAFILAXIA GYANÚ"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            bd_anafilaxia = q_bd1_08.outcome
            if bd_anafilaxia == 1:
                route_allergy = 1
                allergy_severe = 1

        - id: q_bd1_09
          kind: Question
          title: "Verejtékezik a beteg?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        # --- Breathing Difficulty II ---
        - id: q_bd2_01
          kind: Question
          title: "Vérnyomás mérhető-e?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            bp_available = q_bd2_01.outcome

        - id: q_bd2_02
          kind: Question
          title: "Mennyi a szisztolés vérnyomás értéke?"
          precondition:
            - predicate: bp_available == 1
          input:
            control: Radio
            labels:
              1: "220 Hgmm felett"
              2: "200-220 Hgmm"
              3: "200 Hgmm alatt"
          codeBlock: |
            bp_level = q_bd2_02.outcome
            if q_bd2_02.outcome == 1:
                if priority == 0:
                    priority = 2

        - id: q_bd2_03
          kind: Question
          title: "Megváltozott a viselkedése?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_03.outcome == 1:
                bd_neuro_route = 1
                route_neuro = 1

        - id: q_bd2_04
          kind: Question
          title: "Görcsöl a beteg?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_04.outcome == 1:
                route_seizure = 1
                priority = 1

        - id: q_bd2_05
          kind: Question
          title: "Van-e kar gyengeség?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_05.outcome == 1:
                bd_stroke_route = 1
                route_stroke = 1

        - id: q_bd2_06
          kind: Question
          title: "Van-e arc aszimmetria?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
            - predicate: bd_stroke_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_06.outcome == 1:
                bd_stroke_route = 1
                route_stroke = 1

        - id: q_bd2_07
          kind: Question
          title: "Megváltozott-e a beszéde?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
            - predicate: bd_stroke_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_07.outcome == 1:
                bd_stroke_route = 1
                route_stroke = 1

        - id: q_bd2_08
          kind: Question
          title: "Van-e fájdalma?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
            - predicate: bd_stroke_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_08.outcome == 1:
                bd_pain_route = 1
                route_pain = 1

        - id: q_bd2_09
          kind: Question
          title: "Van-e sérülése?"
          precondition:
            - predicate: bd_choking_object == 0
            - predicate: bd_throat_swollen == 0
            - predicate: bd_anafilaxia == 0
            - predicate: bd_neuro_route == 0
            - predicate: bd_stroke_route == 0
            - predicate: bd_pain_route == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_bd2_09.outcome == 1:
                bd_injury_route = 1
                route_injury = 1
            if q_bd2_09.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_AIRWAY - Légúti idegentest (Foreign Body Airway Obstruction) - P11
    # =========================================================================
    - id: b_airway
      title: "Légúti idegentest"
      precondition:
        - predicate: route_airway == 1
      items:
        - id: q_air_01
          kind: Question
          title: "Képes beszélni vagy köhögni?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_air_01.outcome == 0:
                priority = 1

        - id: q_air_02
          kind: Question
          title: "Eszméleténél van a beteg?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_air_02.outcome == 0:
                priority = 1

        - id: q_air_03
          kind: Question
          title: "A beteg kora (légúti idegentest eltávolítás módszeréhez):"
          input:
            control: Radio
            labels:
              1: "Felnőtt vagy gyerek (1 év felett)"
              2: "Csecsemő (1 év alatt)"

    # =========================================================================
    # B_NEURO - Idegrendszer (Nervous System) - P12/51/59
    # =========================================================================
    - id: b_neuro
      title: "Idegrendszeri vizsgálat"
      precondition:
        - predicate: route_neuro == 1
      items:
        - id: q_neuro_01
          kind: Question
          title: "Görcsöl a beteg jelenleg?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_01.outcome == 1:
                route_seizure = 1
                priority = 1

        - id: q_neuro_02
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül (akut)"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            neuro_onset = q_neuro_02.outcome

        - id: q_neuro_03
          kind: Question
          title: "GCS szint / tudatállapot (ha 24 órán belüli panasz):"
          precondition:
            - predicate: neuro_onset == 1
          input:
            control: Radio
            labels:
              1: "GCS 3-9 (mély eszméletlenség) - P1"
              2: "GCS 10-13, agresszív / agitált - P2"
              3: "GCS 14-15, mérsékelt tünetek - P3"
              4: "GCS 14-15, enyhe tünetek - P4"
          codeBlock: |
            if q_neuro_03.outcome == 1:
                priority = 1
            if q_neuro_03.outcome == 2:
                priority = 2
            if q_neuro_03.outcome == 3:
                priority = 3
            if q_neuro_03.outcome == 4:
                priority = 4

        - id: q_neuro_04
          kind: Question
          title: "Van-e kar gyengeség? (FAST teszt)"
          precondition:
            - predicate: q_neuro_01.outcome == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_04.outcome == 1:
                neuro_fast_positive = 1
                route_stroke = 1

        - id: q_neuro_05
          kind: Question
          title: "Van-e arc aszimmetria? (FAST teszt)"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_05.outcome == 1:
                neuro_fast_positive = 1
                route_stroke = 1

        - id: q_neuro_06
          kind: Question
          title: "Megváltozott-e a beszéde? (FAST teszt)"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_06.outcome == 1:
                neuro_fast_positive = 1
                route_stroke = 1

        - id: q_neuro_07
          kind: Question
          title: "Van-e látászavar? (Kettős látás, homályos látás, látótérkiesés?)"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_neuro_08
          kind: Question
          title: "Van-e fejfájása? Ha igen, milyen erős 1-10 skálán?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Radio
            labels:
              1: "Súlyos fejfájás (8-10)"
              2: "Mérsékelt fejfájás (4-7)"
              3: "Enyhe fejfájás (1-3)"
              4: "Nincs fejfájás"

        - id: q_neuro_09
          kind: Question
          title: "Van-e szédülése?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_neuro_10
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_10.outcome == 1:
                if priority == 0:
                    priority = 2

        # --- Exit cascade ---
        - id: q_neuro_11
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            neuro_fever = q_neuro_11.outcome
            if neuro_fever == 1:
                route_fever = 1

        - id: q_neuro_12
          kind: Question
          title: "Van-e fejsérülése?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            neuro_head_injury = q_neuro_12.outcome
            if neuro_head_injury == 1:
                route_injury = 1
                injury_type = 1

        - id: q_neuro_13
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
            - predicate: neuro_head_injury == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            neuro_other_pain = q_neuro_13.outcome
            if neuro_other_pain == 1:
                route_pain = 1

        - id: q_neuro_14
          kind: Question
          title: "Ismert pszichiátriai betegsége van-e?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_14.outcome == 1:
                route_psychiatry = 1

        - id: q_neuro_15
          kind: Question
          title: "Lehetséges-e TIA (átmeneti agyi keringési zavar)?"
          precondition:
            - predicate: q_neuro_01.outcome == 0
            - predicate: neuro_fast_positive == 0
            - predicate: age_group == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_neuro_15.outcome == 1:
                route_stroke = 1

    # =========================================================================
    # B_STROKE - Stroke vizsgálat - P13
    # =========================================================================
    - id: b_stroke
      title: "Stroke vizsgálat"
      precondition:
        - predicate: route_stroke == 1
      items:
        - id: q_stroke_onset
          kind: Question
          title: "Mikor kezdődtek a tünetek?"
          input:
            control: Radio
            labels:
              1: "4.5 órán belül (trombolízis ablak)"
              2: "4.5-24 óra között"
              3: "24 óránál régebben"
          codeBlock: |
            if q_stroke_onset.outcome == 1:
                stroke_onset_lt24h = 1
                priority = 1
            if q_stroke_onset.outcome == 2:
                priority = 1
            if q_stroke_onset.outcome == 3:
                if priority == 0:
                    priority = 2

        - id: q_stroke_arm
          kind: Question
          title: "Kar gyengeség: kérje meg, hogy emelje fel mindkét karját. Lehanyatlik-e az egyik?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_face
          kind: Question
          title: "Arc aszimmetria: kérje meg, hogy mosolyogjon. Lóg-e az egyik arcfele?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_speech
          kind: Question
          title: "Beszédzavar: kérje meg, hogy mondjon egy egyszerű mondatot. Elhúzza-e a szavakat, érthetetlen?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_vision
          kind: Question
          title: "Van-e hirtelen látászavar?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_headache
          kind: Question
          title: "Van-e hirtelen, rendkívül erős fejfájás?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_dizziness
          kind: Question
          title: "Van-e hirtelen szédülés vagy egyensúlyzavar?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_bp_avail
          kind: Question
          title: "Mérhető-e a vérnyomás?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_bp_level
          kind: Question
          title: "Mennyi a szisztolés vérnyomás?"
          precondition:
            - predicate: q_stroke_bp_avail.outcome == 1
          input:
            control: Radio
            labels:
              1: "220 Hgmm felett"
              2: "200-220 Hgmm"
              3: "200 Hgmm alatt"

        - id: q_stroke_syncope
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_blood_thinner
          kind: Question
          title: "Szed-e vérhígítót?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_onset_known
          kind: Question
          title: "Pontosan ismert-e a tünetkezdet időpontja?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_stroke_wakeup
          kind: Question
          title: "Ébredésre vette-e észre a tüneteket (wake-up stroke)?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

    # =========================================================================
    # B_PAIN_ROUTING - Fájdalom helye (Pain Location Routing) - P14
    # =========================================================================
    - id: b_pain_routing
      title: "Fájdalom helye"
      precondition:
        - predicate: route_pain == 1
      items:
        - id: q_pain_01
          kind: Question
          title: "Hol fáj a betegnek?"
          input:
            control: Radio
            labels:
              1: "Fej"
              2: "Mellkas"
              3: "Has"
              4: "Gerinc / hát"
              5: "Végtag"
              6: "Egyéb"
              7: "Várandós - hasi/medencei fájdalom"
          codeBlock: |
            pain_type = q_pain_01.outcome
            if q_pain_01.outcome == 7:
                route_pregnancy = 1

    # =========================================================================
    # B_HEADACHE - Fejfájás (Headache) - P15
    # =========================================================================
    - id: b_headache
      title: "Fejfájás"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 1
      items:
        - id: q_head_01
          kind: Question
          title: "Van-e fejsérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            head_injury_redirect = q_head_01.outcome
            if head_injury_redirect == 1:
                route_injury = 1
                injury_type = 1

        - id: q_head_02
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_head_02.outcome

        - id: q_head_03
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_head_03.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_head_04
          kind: Question
          title: "Van-e látászavar?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_head_05
          kind: Question
          title: "Van-e szédülés?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_head_06
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_head_06.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_head_07
          kind: Question
          title: "Van-e hányinger / hányás?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_head_08_avail
          kind: Question
          title: "Mérhető-e a vérnyomás?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_head_08_level
          kind: Question
          title: "Mennyi a szisztolés vérnyomás?"
          precondition:
            - predicate: q_head_08_avail.outcome == 1
          input:
            control: Radio
            labels:
              1: "220 Hgmm felett"
              2: "200-220 Hgmm"
              3: "200 Hgmm alatt"
          codeBlock: |
            if q_head_08_level.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        # --- Exit cascade ---
        - id: q_head_09
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_head_09.outcome == 1:
                route_fever = 1

        - id: q_head_10
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: head_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_head_10.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_CHEST_PAIN - Mellkasi fájdalom (Chest Pain) - P16
    # =========================================================================
    - id: b_chest_pain
      title: "Mellkasi fájdalom"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 2
      items:
        - id: q_chest_01
          kind: Question
          title: "Van-e mellkas sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            chest_injury_redirect = q_chest_01.outcome
            if chest_injury_redirect == 1:
                route_injury = 1
                injury_type = 2

        - id: q_chest_02
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_chest_02.outcome

        - id: q_chest_03
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_chest_03.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_chest_04
          kind: Question
          title: "Hirtelen lépett-e fel a fájdalom?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_chest_04.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_chest_05
          kind: Question
          title: "Milyen típusú a fájdalom?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Retrosternalis / szorító / anginás típusú"
              2: "Atípusos (szúró, felszínes, légzéssel összefüggő)"
          codeBlock: |
            if q_chest_05.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_chest_06_avail
          kind: Question
          title: "Mérhető-e a vérnyomás?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_chest_06_level
          kind: Question
          title: "Mennyi a szisztolés vérnyomás?"
          precondition:
            - predicate: q_chest_06_avail.outcome == 1
          input:
            control: Radio
            labels:
              1: "220 Hgmm felett"
              2: "200-220 Hgmm"
              3: "200 Hgmm alatt"
          codeBlock: |
            if q_chest_06_level.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_chest_07
          kind: Question
          title: "Van-e MVT/PE (mélyvénás trombózis / tüdőembólia) kockázati tényező?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_chest_07.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_chest_08
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_chest_08.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_chest_09
          kind: Question
          title: "Van-e hányinger / hányás?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        # --- Exit cascade ---
        - id: q_chest_10
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_chest_10.outcome == 1:
                route_fever = 1

        - id: q_chest_11
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: chest_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_chest_11.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_ABDOMINAL_PAIN - Hasi fájdalom I+II (Abdominal Pain) - P17-18
    # =========================================================================
    - id: b_abdominal_pain
      title: "Hasi fájdalom"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 3
      items:
        - id: q_abdo_01
          kind: Question
          title: "Van-e hasi sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abdo_injury_redirect = q_abdo_01.outcome
            if abdo_injury_redirect == 1:
                route_injury = 1
                injury_type = 3

        - id: q_abdo_02
          kind: Question
          title: "Terhes-e a beteg?"
          precondition:
            - predicate: abdo_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            abdo_pregnancy_redirect = q_abdo_02.outcome
            if abdo_pregnancy_redirect == 1:
                route_pregnancy = 1

        - id: q_abdo_03
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_abdo_03.outcome

        - id: q_abdo_04
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_abdo_04.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_abdo_05
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_abdo_05.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_abdo_06
          kind: Question
          title: "Milyen a hányás típusa?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "Véres / kávéaljszerű, nagy mennyiségű"
              2: "Kávéaljszerű, kis mennyiségű"
              3: "Ételes / vizes, csillapíthatatlan"
              4: "Ételes / vizes, kis mennyiségű"
              5: "Nincs hányás"
          codeBlock: |
            if q_abdo_06.outcome == 1:
                priority = 1
            if q_abdo_06.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_abdo_07
          kind: Question
          title: "Vizelet elakadás van-e? Ha igen, mióta?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "Igen, 24 óránál régebben"
              2: "Igen, 24 órán belül"
              3: "Nincs vizelet elakadás"

        - id: q_abdo_08
          kind: Question
          title: "Mikor volt utoljára székelés?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "Több mint 3 napja"
              2: "1-3 napja"
              3: "Ma / tegnap"

        - id: q_abdo_09
          kind: Question
          title: "Milyen a széklet?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Dropdown
            labels:
              1: "Véres / fekete / nagy mennyiségű"
              2: "Fekete, kis mennyiségű"
              3: "Véres, kis mennyiségű"
              4: "Hasmenés, csillapíthatatlan"
              5: "Hasmenés, enyhe"
              6: "Normális"
          codeBlock: |
            if q_abdo_09.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_abdo_10
          kind: Question
          title: "Van-e hüvelyi vérzés?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Radio
            labels:
              1: "Masszív vérzés"
              2: "Méhen kívüli terhesség gyanú"
              3: "Mérsékelt vérzés"
              4: "Enyhe vérzés"
              5: "Nincs hüvelyi vérzés"
          codeBlock: |
            if q_abdo_10.outcome == 1:
                priority = 1
            if q_abdo_10.outcome == 2:
                priority = 1

        # --- Exit cascade ---
        - id: q_abdo_11
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_abdo_11.outcome == 1:
                route_fever = 1

        - id: q_abdo_12
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: abdo_injury_redirect == 0
            - predicate: abdo_pregnancy_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_abdo_12.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_BACK_PAIN - Gerincfájdalom (Back Pain) - P19
    # =========================================================================
    - id: b_back_pain
      title: "Gerinc- / hátfájás"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 4
      items:
        - id: q_back_01
          kind: Question
          title: "Van-e gerinc sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            spine_injury_redirect = q_back_01.outcome
            if spine_injury_redirect == 1:
                route_injury = 1
                injury_type = 4

        - id: q_back_02
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_back_02.outcome

        - id: q_back_03
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_back_03.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_back_04
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_back_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_back_05
          kind: Question
          title: "Van-e végtagzsibbadás vagy bénulás?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_back_05.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_back_06
          kind: Question
          title: "Tartja-e a székletét és vizeletét?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem (inkontinencia)"
            on: "Igen"
          codeBlock: |
            if q_back_06.outcome == 0:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_back_07
          kind: Question
          title: "Szed-e vérhígítót?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_back_08
          kind: Question
          title: "Van-e ismert vérzékenysége?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        # --- Exit cascade ---
        - id: q_back_09
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_back_09.outcome == 1:
                route_fever = 1

        - id: q_back_10
          kind: Question
          title: "Van-e kockázati tényező? (Daganat, fertőzés, immunszuppresszió, stb.)"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_back_10.outcome == 1:
                if priority == 0 or priority > 3:
                    priority = 3

        - id: q_back_11
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: spine_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_back_11.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_LIMB_PAIN - Végtagfájdalom (Limb Pain) - P20
    # =========================================================================
    - id: b_limb_pain
      title: "Végtagfájdalom"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 5
      items:
        - id: q_limb_p_01
          kind: Question
          title: "Van-e végtag sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            limb_injury_redirect = q_limb_p_01.outcome
            if limb_injury_redirect == 1:
                route_injury = 1
                injury_type = 5

        - id: q_limb_p_02_onset
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_limb_p_02_onset.outcome

        - id: q_limb_p_02_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_limb_p_02_sev.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_limb_p_03
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_limb_p_03.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_limb_p_04
          kind: Question
          title: "Tudja-e mozgatni a végtagot?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_limb_p_05
          kind: Question
          title: "Duzzadt-e a végtag?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_limb_p_06
          kind: Question
          title: "Van-e szín változás a végtagon?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Kékes / lila"
              2: "Sápadt / fehér"
              3: "Piros"
              4: "Nincs változás"
          codeBlock: |
            if q_limb_p_06.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2
            if q_limb_p_06.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_limb_p_07
          kind: Question
          title: "Van-e hőmérséklet változás a végtagon?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Hideg"
              2: "Meleg"
              3: "Nincs változás"
          codeBlock: |
            if q_limb_p_07.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        # --- Exit cascade ---
        - id: q_limb_p_08
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_limb_p_08.outcome == 1:
                route_fever = 1

        - id: q_limb_p_09
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: limb_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_limb_p_09.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_OTHER_PAIN - Egyéb fájdalom (Other Pain) - P21
    # =========================================================================
    - id: b_other_pain
      title: "Egyéb fájdalom"
      precondition:
        - predicate: route_pain == 1
        - predicate: pain_type == 6
      items:
        - id: q_other_p_01
          kind: Question
          title: "Megsérülhetett-e? (Van-e sérülés nyoma?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            other_pain_injury_redirect = q_other_p_01.outcome
            if other_pain_injury_redirect == 1:
                route_injury = 1

        - id: q_other_p_02
          kind: Question
          title: "Mikor kezdődtek a panaszok?"
          precondition:
            - predicate: other_pain_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_other_p_02.outcome

        - id: q_other_p_03
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          precondition:
            - predicate: other_pain_injury_redirect == 0
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_other_p_03.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_other_p_04
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: other_pain_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_other_p_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        # --- Exit cascade ---
        - id: q_other_p_05
          kind: Question
          title: "Lázas-e a beteg?"
          precondition:
            - predicate: other_pain_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_other_p_05.outcome == 1:
                route_fever = 1

        - id: q_other_p_06
          kind: Question
          title: "Van-e fájdalma máshol?"
          precondition:
            - predicate: other_pain_injury_redirect == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_other_p_06.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_INJURY_ROUTING - Sérülés helye (Injury Location Routing) - P26
    # =========================================================================
    - id: b_injury_routing
      title: "Sérülés helye"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 0
      items:
        - id: q_inj_01
          kind: Question
          title: "Van-e vérzés?"
          input:
            control: Radio
            labels:
              1: "Nincs vagy enyhe vérzés"
              2: "Mérsékelt vérzés"
              3: "Súlyos, csillapíthatatlan vérzés"
          codeBlock: |
            if q_inj_01.outcome == 3:
                priority = 1
            if q_inj_01.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_inj_02
          kind: Question
          title: "Hol van a sérülés?"
          input:
            control: Radio
            labels:
              1: "Fej"
              2: "Mellkas"
              3: "Has"
              4: "Gerinc"
              5: "Végtag"
              6: "Égési sérülés"
          codeBlock: |
            injury_type = q_inj_02.outcome

    # =========================================================================
    # B_HEAD_INJURY - Fejsérülés (Head Injury) - P27
    # =========================================================================
    - id: b_head_injury
      title: "Fejsérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 1
      items:
        - id: q_hinj_01_onset
          kind: Question
          title: "Mikor történt a sérülés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_hinj_01_onset.outcome

        - id: q_hinj_01_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_hinj_01_sev.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_hinj_02
          kind: Question
          title: "Van-e látászavar?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_hinj_03
          kind: Question
          title: "Van-e szédülés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_hinj_04
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_hinj_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_hinj_05
          kind: Question
          title: "Van-e hányinger / hányás?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_hinj_06
          kind: Question
          title: "Szed-e vérhígítót?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_hinj_06.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_hinj_07
          kind: Question
          title: "Van-e ismert vérzékenysége?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_hinj_07.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_hinj_08
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_hinj_08.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_CHEST_INJURY - Mellkassérülés (Chest Injury) - P28
    # =========================================================================
    - id: b_chest_injury
      title: "Mellkassérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 2
      items:
        - id: q_cinj_01_onset
          kind: Question
          title: "Mikor történt a sérülés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_cinj_01_onset.outcome

        - id: q_cinj_01_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_cinj_01_sev.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_cinj_02
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_cinj_02.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_cinj_03
          kind: Question
          title: "Szed-e vérhígítót?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_cinj_03.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_cinj_04
          kind: Question
          title: "Van-e ismert vérzékenysége?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_cinj_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_cinj_05
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_cinj_05.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_ABDO_INJURY - Hasi sérülés (Abdominal Injury) - P29
    # =========================================================================
    - id: b_abdo_injury
      title: "Hasi sérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 3
      items:
        - id: q_ainj_01_onset
          kind: Question
          title: "Mikor történt a sérülés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_ainj_01_onset.outcome

        - id: q_ainj_01_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_ainj_01_sev.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_ainj_02
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_ainj_02.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_ainj_03
          kind: Question
          title: "Szed-e vérhígítót?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_ainj_03.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_ainj_04
          kind: Question
          title: "Van-e ismert vérzékenysége?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_ainj_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_ainj_05
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_ainj_05.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_SPINE_INJURY - Gerincsérülés (Spine Injury) - P30
    # =========================================================================
    - id: b_spine_injury
      title: "Gerincsérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 4
      items:
        - id: q_sinj_01_onset
          kind: Question
          title: "Mikor történt a sérülés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_sinj_01_onset.outcome

        - id: q_sinj_01_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_sinj_01_sev.outcome
            if onset == 1 and severity == 1:
                priority = 1
            if onset == 1 and severity == 2:
                priority = 2
            if onset == 1 and severity == 3:
                priority = 3
            if onset == 2 and severity == 1:
                priority = 2
            if onset == 2 and severity == 2:
                priority = 3
            if onset == 2 and severity == 3:
                priority = 4
            if onset == 3 and severity == 1:
                priority = 3
            if onset == 3 and severity == 2:
                priority = 4
            if onset == 3 and severity == 3:
                priority = 5

        - id: q_sinj_02
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_sinj_02.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_sinj_03
          kind: Question
          title: "Van-e végtagzsibbadás vagy bénulás?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_sinj_03.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_sinj_04
          kind: Question
          title: "Szed-e vérhígítót?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_sinj_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_sinj_05
          kind: Question
          title: "Van-e ismert vérzékenysége?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_sinj_05.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_sinj_06
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_sinj_06.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_LIMB_INJURY - Végtagsérülés (Limb Injury) - P31
    # =========================================================================
    - id: b_limb_injury
      title: "Végtagsérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 5
      items:
        - id: q_linj_01
          kind: Question
          title: "Amputáció történt-e? (Végtag / ujj leszakadás?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_linj_01.outcome == 1:
                priority = 1

        - id: q_linj_02_onset
          kind: Question
          title: "Mikor történt a sérülés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "1 héten belül"
              3: "1 hétnél régebben"
          codeBlock: |
            onset = q_linj_02_onset.outcome

        - id: q_linj_02_sev
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Súlyos (8-10)"
              2: "Mérsékelt (4-7)"
              3: "Enyhe (1-3)"
          codeBlock: |
            severity = q_linj_02_sev.outcome
            if onset == 1 and severity == 1:
                if priority == 0:
                    priority = 1
            if onset == 1 and severity == 2:
                if priority == 0 or priority > 2:
                    priority = 2
            if onset == 1 and severity == 3:
                if priority == 0 or priority > 3:
                    priority = 3
            if onset == 2 and severity == 1:
                if priority == 0 or priority > 2:
                    priority = 2
            if onset == 2 and severity == 2:
                if priority == 0 or priority > 3:
                    priority = 3
            if onset == 2 and severity == 3:
                if priority == 0 or priority > 4:
                    priority = 4
            if onset == 3 and severity == 1:
                if priority == 0 or priority > 3:
                    priority = 3
            if onset == 3 and severity == 2:
                if priority == 0 or priority > 4:
                    priority = 4
            if onset == 3 and severity == 3:
                if priority == 0 or priority > 5:
                    priority = 5

        - id: q_linj_03
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_linj_03.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_linj_04
          kind: Question
          title: "Szed-e vérhígítót, vagy van-e ismert vérzékenysége?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_linj_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_linj_05
          kind: Question
          title: "Tudja-e mozgatni a végtagot?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_linj_06
          kind: Question
          title: "Duzzadt vagy deformált-e a végtag?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_linj_07
          kind: Question
          title: "Van-e szín változás a végtagon?"
          input:
            control: Radio
            labels:
              1: "Kékes / lila"
              2: "Sápadt / fehér"
              3: "Piros"
              4: "Nincs változás"
          codeBlock: |
            if q_linj_07.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2
            if q_linj_07.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_linj_08
          kind: Question
          title: "Van-e hőmérséklet változás a végtagon?"
          input:
            control: Radio
            labels:
              1: "Hideg"
              2: "Meleg"
              3: "Nincs változás"
          codeBlock: |
            if q_linj_08.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_linj_09
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_linj_09.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_BURNS - Égési sérülés (Burns) - P32
    # =========================================================================
    - id: b_burns
      title: "Égési sérülés"
      precondition:
        - predicate: route_injury == 1
        - predicate: injury_type == 6
      items:
        - id: q_burn_01
          kind: Question
          title: "Mikor történt az égés?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "24 óránál régebben"

        - id: q_burn_02
          kind: Question
          title: "Hogyan történt az égés?"
          input:
            control: Radio
            labels:
              1: "Tűz zárt térben (füstbelélegzés veszély)"
              2: "Robbanás"
              3: "Elektromos áram"
              4: "Forró folyadék"
              5: "Vegyi anyag"
          codeBlock: |
            if q_burn_02.outcome == 1:
                priority = 1
            if q_burn_02.outcome == 2:
                priority = 1

        - id: q_burn_03
          kind: Question
          title: "Hogyan néz ki az égett terület?"
          input:
            control: Radio
            labels:
              1: "Szürke / fekete (III. fokú)"
              2: "Hólyagos (II. fokú)"
              3: "Piros / bőrpír (I. fokú)"
          codeBlock: |
            if q_burn_03.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_burn_04
          kind: Question
          title: "Hol van az égési sérülés?"
          input:
            control: Radio
            labels:
              1: "Arc / nyak (légút veszély)"
              2: "Mellkas"
              3: "Has / nemi szervek"
              4: "Végtagok"
          codeBlock: |
            if q_burn_04.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_burn_05
          kind: Question
          title: "Milyen erős a fájdalom 1-10 skálán?"
          input:
            control: Radio
            labels:
              1: "Mérsékelt-súlyos (4-10)"
              2: "Enyhe vagy nincs (0-3)"

        - id: q_burn_06
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_burn_06.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_burn_07
          kind: Question
          title: "Van-e máshol is sérülése?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_burn_07.outcome == 0:
                route_condition_overview = 1

    # =========================================================================
    # B_ALLERGY_SEVERE - Súlyos allergiás reakció (Severe Allergic Reaction) - P34-35
    # =========================================================================
    - id: b_allergy_severe
      title: "Súlyos allergiás reakció / Anafilaxia"
      precondition:
        - predicate: route_allergy == 1
      items:
        - id: q_alrg_01
          kind: Question
          title: "Allergiás reakció merül-e fel? (Ismert allergén expozíció, bőrtünetek, duzzanat?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_alrg_01.outcome == 1:
                allergy_severe = 1
            if q_alrg_01.outcome == 0:
                allergy_mild = 1

        - id: q_alrg_02
          kind: Question
          title: "Tud-e beszélni?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Radio
            labels:
              1: "Csak szavakat mond"
              2: "Rövid mondatokat mond"
              3: "Teljes mondatokat mond"
          codeBlock: |
            if q_alrg_02.outcome == 1:
                priority = 1

        - id: q_alrg_03
          kind: Question
          title: "Milyen a légzési munka?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Radio
            labels:
              1: "Kimerült / súlyos"
              2: "Mérsékelt"
              3: "Enyhe"
          codeBlock: |
            if q_alrg_03.outcome == 1:
                priority = 1
            if q_alrg_03.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_alrg_04
          kind: Question
          title: "Szokatlan-e a bőre? (Sápadt, kékes, kipirult, csalánkiütés?)"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_alrg_05
          kind: Question
          title: "Verejtékezik a beteg?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_alrg_06
          kind: Question
          title: "Megváltozott-e a viselkedése? (Zavart, nyugtalan?)"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_alrg_06.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_alrg_07
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_alrg_07.outcome == 1:
                priority = 1

        - id: q_alrg_08
          kind: Question
          title: "Van-e hasi panasza? (Hányinger, hányás, hasmenés, görcs?)"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_alrg_09
          kind: Question
          title: "Elérhető-e adrenalin injekció (EpiPen/Anapen)?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_alrg_10
          kind: Question
          title: "Van-e képzett személy a helyszínen, aki be tudja adni?"
          precondition:
            - predicate: allergy_severe == 1
            - predicate: q_alrg_09.outcome == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_alrg_11
          kind: Question
          title: "Ismert allergiája van-e a betegnek?"
          precondition:
            - predicate: allergy_severe == 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

    # =========================================================================
    # B_ALLERGY_MILD - Enyhe allergiás reakció (Mild Allergic Reaction) - P36
    # =========================================================================
    - id: b_allergy_mild
      title: "Enyhe allergiás reakció"
      precondition:
        - predicate: allergy_mild == 1
      items:
        - id: q_malrg_01
          kind: Question
          title: "Ismert allergiája van-e a betegnek?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_malrg_02
          kind: Question
          title: "Van-e bőrpír vagy csalánkiütés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_malrg_03
          kind: Question
          title: "Mikor kezdődtek a tünetek?"
          input:
            control: Radio
            labels:
              1: "24 órán belül"
              2: "24 óránál régebben"
          codeBlock: |
            if q_malrg_03.outcome == 1:
                if priority == 0 or priority > 3:
                    priority = 3
            if q_malrg_03.outcome == 2:
                if priority == 0 or priority > 4:
                    priority = 4

        - id: q_malrg_04
          kind: Question
          title: "Volt-e ájulás / eszméletvesztés?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_malrg_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_malrg_05
          kind: Question
          title: "Van-e hasi panasza?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_malrg_06
          kind: Question
          title: "Csak helyi (lokális) reakció van-e?"
          input:
            control: Switch
            off: "Nem (szisztémás)"
            on: "Igen (csak helyi)"
          codeBlock: |
            if q_malrg_06.outcome == 1:
                if priority == 0 or priority > 4:
                    priority = 4
            if q_malrg_06.outcome == 0:
                if priority == 0 or priority > 3:
                    priority = 3

    # =========================================================================
    # B_PSYCHIATRY - Pszichiátria (Psychiatry) - P33
    # =========================================================================
    - id: b_psychiatry
      title: "Pszichiátria"
      precondition:
        - predicate: route_psychiatry == 1
      items:
        - id: q_psych_01
          kind: Question
          title: "Fenyegetőzik vagy agresszív-e a beteg?"
          input:
            control: Radio
            labels:
              1: "Veszélyes (fegyver, közvetlen fenyegetés)"
              2: "Ismeretlen / bizonytalan"
              3: "Csak gondolatok szintjén"
              4: "Nem"
          codeBlock: |
            if q_psych_01.outcome == 1:
                priority = 1
            if q_psych_01.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_psych_02
          kind: Question
          title: "Öngyilkossággal fenyegetőzik-e?"
          input:
            control: Radio
            labels:
              1: "Öngyilkossági kísérlet történt"
              2: "Aktív szándék (terv, eszköz)"
              3: "Ismeretlen / bizonytalan"
              4: "Csak gondolatok szintjén"
              5: "Nem"
          codeBlock: |
            if q_psych_02.outcome == 1:
                priority = 1
            if q_psych_02.outcome == 2:
                if priority == 0 or priority > 1:
                    priority = 1
            if q_psych_02.outcome == 3:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_psych_03
          kind: Question
          title: "Szorongás vagy hallucináció van-e?"
          input:
            control: Dropdown
            labels:
              1: "Súlyos szorongás (pánik, önveszélyes)"
              2: "Akut pszichózis (hallucináció, téveszmék)"
              3: "Ismeretlen / bizonytalan"
              4: "Mérsékelt szorongás"
              5: "Enyhe szorongás"
              6: "Krónikus pszichiátriai állapot"
              7: "Nincs"
          codeBlock: |
            if q_psych_03.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2
            if q_psych_03.outcome == 2:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_psych_04
          kind: Question
          title: "Bántalmazás vagy álmatlanság áll-e fenn?"
          input:
            control: Radio
            labels:
              1: "Bántalmazás (fizikai / lelki)"
              2: "Akut álmatlanság"
              3: "Krónikus álmatlanság"
              4: "Nincs"
          codeBlock: |
            if q_psych_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_psych_05
          kind: Question
          title: "Fogyasztott-e tudatmódosító szert? (Alkohol, drog, gyógyszer?)"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_psych_05.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_psych_06
          kind: Question
          title: "Megsérülhetett-e a beteg?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_psych_06.outcome == 1:
                route_injury = 1

    # =========================================================================
    # B_PREGNANCY - Várandósság (Pregnancy) - P37
    # =========================================================================
    - id: b_pregnancy
      title: "Várandósság"
      precondition:
        - predicate: route_pregnancy == 1
      items:
        - id: q_preg_01
          kind: Question
          title: "Látható-e magzati rész (fej, végtag, köldökzsinór)?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            preg_visible_part = q_preg_01.outcome
            if preg_visible_part == 1:
                priority = 1
                preg_imminent_birth = 1

        - id: q_preg_02
          kind: Question
          title: "Mennyi idős a terhesség?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Radio
            labels:
              1: "36 hétnél kevesebb (koraszülés veszély)"
              2: "36 hetes vagy több"
          codeBlock: |
            if q_preg_02.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_preg_03
          kind: Question
          title: "Hányadik terhesség?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Radio
            labels:
              1: "Első terhesség"
              2: "Többedik terhesség"

        - id: q_preg_04
          kind: Question
          title: "Veszélyeztetett terhesség-e? (Ismert kockázatok?)"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_preg_04.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_preg_05
          kind: Question
          title: "Elfolyt-e a magzatvíz?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_preg_06
          kind: Question
          title: "Milyen gyakran jönnek a fájások?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Radio
            labels:
              1: "2 percnél sűrűbben"
              2: "2 percnél ritkábban"
          codeBlock: |
            if q_preg_06.outcome == 1:
                preg_imminent_birth = 1
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_preg_07
          kind: Question
          title: "Érez-e székelési / nyomási ingert? (Tolóerő?)"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_preg_07.outcome == 1:
                preg_imminent_birth = 1
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_preg_08
          kind: Question
          title: "Van-e vérzés?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Radio
            labels:
              1: "Masszív vérzés"
              2: "Enyhe vagy nincs"
          codeBlock: |
            if q_preg_08.outcome == 1:
                priority = 1

        - id: q_preg_09
          kind: Question
          title: "Mi a magzat fekvés (ha ismert)?"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Radio
            labels:
              1: "Koponya fekvés (fejjel lefelé)"
              2: "Farfekvés"
              3: "Harántfekvés"
              4: "Nem ismert"

        - id: q_preg_10
          kind: Question
          title: "Vannak-e preeclampsia tünetei? (Magas vérnyomás, fejfájás, látászavar, duzzanat?)"
          precondition:
            - predicate: preg_visible_part == 0
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_preg_10.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

    # =========================================================================
    # B_BIRTH - Helyszíni szülés (On-Scene Birth Assessment) - P38
    # =========================================================================
    - id: b_birth
      title: "Helyszíni szülés - Újszülött vizsgálat"
      precondition:
        - predicate: preg_imminent_birth == 1
      items:
        - id: q_birth_01
          kind: Question
          title: "Lélegzik vagy sír a baba?"
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_birth_01.outcome == 0:
                priority = 1

        - id: q_birth_02
          kind: Question
          title: "Időre született-e a baba? (36 hetes vagy több?)"
          input:
            control: Switch
            off: "Nem (koraszülött)"
            on: "Igen"
          codeBlock: |
            if q_birth_02.outcome == 0:
                priority = 1

        - id: q_birth_03
          kind: Question
          title: "Milyen a baba izomtónusa?"
          input:
            control: Radio
            labels:
              1: "Jó tónus (aktívan mozog)"
              2: "Petyhüdt (floppy, nem mozog)"
          codeBlock: |
            if q_birth_03.outcome == 2:
                priority = 1

    # =========================================================================
    # B_FEVER - Láz I+II (Fever) - P22-23
    # =========================================================================
    - id: b_fever
      title: "Láz"
      precondition:
        - predicate: route_fever == 1
      items:
        - id: q_fever_01
          kind: Question
          title: "Hány éves a lázas beteg?"
          input:
            control: Radio
            labels:
              1: "0-3 hónapos"
              2: "3 hónapos - 3 éves"
              3: "3-18 éves"
              4: "18 éves felett"
          codeBlock: |
            fever_age_cat = q_fever_01.outcome
            if fever_age_cat == 1:
                priority = 1

        - id: q_fever_02
          kind: Question
          title: "Betegnek tűnik-e a gyermek? (Irritábilis, nem eszik, nehezen ébreszthető?)"
          precondition:
            - predicate: fever_age_cat == 2 or fever_age_cat == 3
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_02.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_03
          kind: Question
          title: "39°C feletti láza van-e?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_03.outcome == 1:
                if priority == 0 or priority > 3:
                    priority = 3

        - id: q_fever_04
          kind: Question
          title: "Mióta lázas?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Radio
            labels:
              1: "Több mint 5 napja"
              2: "3-5 napja"
              3: "3 napnál kevesebb"
          codeBlock: |
            if q_fever_04.outcome == 1:
                if priority == 0 or priority > 3:
                    priority = 3

        - id: q_fever_05
          kind: Question
          title: "Csökkenti-e a lázcsillapító a lázat?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_fever_06
          kind: Question
          title: "Kapott-e antibiotikumot az elmúlt 24 órában?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"

        - id: q_fever_07
          kind: Question
          title: "Mikor vizelt utoljára?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Radio
            labels:
              1: "Több mint 24 órája"
              2: "6-12 órája"
              3: "6 óránál kevesebb"
          codeBlock: |
            if q_fever_07.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_08
          kind: Question
          title: "Van-e vérképzőszervi betegsége?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_08.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_09
          kind: Question
          title: "Kap-e kemoterápiát?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_09.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_10
          kind: Question
          title: "Szed-e szteroidot (immunszuppresszáns)?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_10.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_11
          kind: Question
          title: "Volt-e műtéte az elmúlt 1 hónapban?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_11.outcome == 1:
                if priority == 0 or priority > 3:
                    priority = 3

        - id: q_fever_12
          kind: Question
          title: "Van-e műbillentyűje?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_12.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

        - id: q_fever_13
          kind: Question
          title: "Van-e bőrkiütés vagy bevérzés (petechia)?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_13.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

        - id: q_fever_14
          kind: Question
          title: "Van-e nyakmerevség?"
          precondition:
            - predicate: fever_age_cat != 1
          input:
            control: Switch
            off: "Nem"
            on: "Igen"
          codeBlock: |
            if q_fever_14.outcome == 1:
                if priority == 0 or priority > 1:
                    priority = 1

    # =========================================================================
    # B_SEIZURE - Görcsroham (Seizure) - P40
    # =========================================================================
    - id: b_seizure
      title: "Görcsroham"
      precondition:
        - predicate: route_seizure == 1
      items:
        - id: q_seiz_01
          kind: Question
          title: "Megszűnt-e a görcsroham?"
          input:
            control: Switch
            off: "Nem (aktív görcsölés)"
            on: "Igen (megállt)"
          codeBlock: |
            if q_seiz_01.outcome == 0:
                priority = 1
            if q_seiz_01.outcome == 1:
                if priority == 0 or priority > 2:
                    priority = 2

    # =========================================================================
    # B_CONDITION_OVERVIEW - Kórállapot Áttekintő (Condition Overview) - P60-63
    # =========================================================================
    - id: b_condition_overview
      title: "Kórállapot áttekintő"
      precondition:
        - predicate: route_condition_overview == 1
      items:
        - id: q_cond_01
          kind: Question
          title: "Mi a beteg fő panasza / állapota?"
          input:
            control: Dropdown
            labels:
              1: "Általános rosszullét"
              2: "Vérnyomásprobléma (magas/alacsony)"
              3: "Szívritmuszavar / szívdobogás"
              4: "Cukorbetegség - vércukor probléma"
              5: "Mérgezés / túladagolás"
              6: "Allergiás reakció"
              7: "Vérzés (nem sérülés)"
              8: "Szem panasz"
              9: "Fül / orr / torok panasz"
              10: "Bőrpanasz"
              11: "Húgyúti panasz"
              12: "Nőgyógyászati panasz"
              13: "Hányás / hasmenés"
              14: "Végtagduzzanat"
              15: "Krónikus állapot rosszabbodása"
              16: "Szállítás igény (fekvőbeteg)"
              17: "Egyéb - nem besorolható"
          codeBlock: |
            if q_cond_01.outcome == 3:
                if priority == 0 or priority > 2:
                    priority = 2
            if q_cond_01.outcome == 4:
                if priority == 0 or priority > 2:
                    priority = 2
            if q_cond_01.outcome == 5:
                if priority == 0 or priority > 1:
                    priority = 1
            if q_cond_01.outcome == 7:
                if priority == 0 or priority > 2:
                    priority = 2
            if priority == 0:
                priority = 4
