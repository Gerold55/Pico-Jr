-- levels

function init_levels()
    level1 = {
        stage1 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id },
                { windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id },
                { windows_sprites.fixed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.fixed.id }
            },
            target = 10,
            progress = 0
        },
        stage2 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken.id },
                { windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken.id }
            },
            target = 12,
            progress = 0
        },
        stage3 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken.id },
                { windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id }
            },
            target = 12,
            progress = 0
        }
    }

    level2 = {
        stage1 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.fixed_plants.id, windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed_plants.id },
                { windows_sprites.fixed.id, windows_sprites.fixed_plants.id, windows_sprites.fixed_plants.id, windows_sprites.fixed.id },
                { windows_sprites.fixed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.fixed.id }
            },
            target = 10,
            progress = 0
        },
        stage2 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id }
            },
            target = 12,
            progress = 0
        },
        stage3 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id, windows_sprites.broken_plants.id }
            },
            target = 12,
            progress = 0
        }
    }

    level3 = {
        stage1 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.fixed.id, windows_sprites.fixed_plants.id, windows_sprites.fixed_plants.id, windows_sprites.fixed.id },
                { windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id, windows_sprites.fixed.id },
                { windows_sprites.fixed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.fixed.id }
            },
            target = 10,
            progress = 0
        },
        stage2 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken.id, windows_sprites.broken_plants.id }
            },
            target = 12,
            progress = 0
        },
        stage3 = {
            to_fix = { 
                { windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id, windows_sprites.closed.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken.id },
                { windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken_plants.id },
                { windows_sprites.broken_plants.id, windows_sprites.broken.id, windows_sprites.broken_plants.id, windows_sprites.broken.id }
            },
            target = 12,
            progress = 0
        }
    }
end