box.cfg {
    listen = 3301,
    replication = {
        'replicator:password@tt-node-1:3301',
        'replicator:password@tt-node-2:3301',
    },
    read_only = false
}

local track_model = {
    space_name = 'tracks'
}

local offercap_model = {
    space_name = 'offercaps'
}

local primary_index = 'primary'

local schema = {}

function schema.create(model)
    local track_space = box.schema.space.create(model.space_name, {
        engine = 'vinyl',
        if_not_exists = true
    })

    track_space:create_index(primary_index, {
        type = 'tree',
        unique = true,
        parts = { 1, 'string' },
        page_size = 128 * 1024,
        if_not_exists = true
    })
end

box.once("bootstrap", function()
    box.schema.user.create('replicator', { password = 'password' })
    box.schema.user.grant('replicator', 'replication')
    print('box.once executed on replica')
    schema.create(track_model)
    schema.create(offercap_model)
end)