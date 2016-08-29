module Constants
    ACTOR_ACTION_TYPE = { debit: -1, credit: 1 }
    ACTOR_DEFAULTS = {
        driver: ACTOR_ACTION_TYPE[:debit],
        owner: ACTOR_ACTION_TYPE[:credit],
        insurance: ACTOR_ACTION_TYPE[:credit],
        assistance: ACTOR_ACTION_TYPE[:credit],
        drivy: ACTOR_ACTION_TYPE[:credit]
    }
    DISCOUNTS = {
        '1' => 0.9,
        '4' => 0.7,
        '10' => 0.5
    }
    COMMISION_RATE = 0.3
    INSURANCE_COMISSION_RATE = 0.5
    ROADSIDE_PRICE_PER_DAY = 1 * 100 # PRICES ARE IN CENTS
    DEDUCTIBLE = 800 * 100
    DEDUCTIBLE_CHARGE_PER_DAY = 4 * 100
end
