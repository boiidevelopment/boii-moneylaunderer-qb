----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Language settings
Language = {
    Ped = {
        ['blip'] = 'Money Wash', -- Blip string
    },
    Washing = {
        ['enoughcops'] = 'Not enough active officers! Required: ('..Config.MoneyWash.RequiredCops..')..',
        ['cancelled'] = 'Action cancelled, your money has been returned.', -- Notification
        ['wait'] = 'Waiting For Payment', -- Progressbar
    },
    Alert = {
        ['blip'] = '10-66: Suspicious Person in Area!', -- Blip string
        ['notif'] = '10-66: Suspicious Person in Area!', -- Police notification
    }
}