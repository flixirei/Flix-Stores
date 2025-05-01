return {
    stores = {
        pawnshop = {
            ped = {
                model = 'cs_movpremmale',
                coords = vec4(-2297.3, 290.97, 169.6, 116.2),
                scenario = 'WORLD_HUMAN_SMOKING',
                label = 'Pawnshop',
                icon = 'fa-solid fa-cash-register'
            },

            blip = {
                sprite = 59,
                color = 29,
                scale = 0.8,
                enable = true
            },
        },

        -- You can add more stores here
        --[[
        example = {
            ped = {
                model = 'cs_movpremmale',
                coords = vec4(-2297.3, 290.97, 169.6, 116.2),
                scenario = 'WORLD_HUMAN_SMOKING',
                label = 'Example Store',
                icon = 'fa-solid fa-crown'
            },

            blip = {
                sprite = 617,
                color = 1,
                scale = 0.8,
                enable = true
            },
        },]]

    },

    items = {
        water = {price = 15, store = 'pawnshop'},
    --  example = {price = 500, store = 'example'},
    }
}
