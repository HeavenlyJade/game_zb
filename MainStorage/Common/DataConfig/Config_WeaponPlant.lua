local Config_weaponPlant = {
    ["PeaShooter"] = {
        -- 武器类型
        gun_type = 5,
        shooting_mode = {1},
        -- 植物资源
        plant_res = "",
        plant_icon1 = "",
        plant_icon2 = "",
        -- 武器参数

        --射击频率(毫秒/发)
        fire_rate = 120,
        --装弹参数
        reload_type = 1.000000,
        reload_time = 1500.000000,
        -- 伤害参数
        attack_max = 45.000000,
        damage_head = 28.000000,
        damage_body = 100.000000,
        --伤害衰减
        attenuation_distance_body = 45.000000,
        attack_min_body = 8.000000,
        attenuation_distance_head = 30.000000,
        attack_min_head = 19.000000,
        attack_through = 0.200000,
        -- 最大射程
        max_range = 300.000000,
        -- 弹夹参数
        magazine = 30.000000,
        magazine_carry = 99999.000000,
        --speed_influence = 0.7,

        --开火动作后等待时间
        FireAction_time = 0.000000,
        --准星
        crossHair_mode = 1.000000,
        -- 后座力参数
        vertical_recoil = {0.01, 0.01, 0.01, 0.01, 0.01},
        vertical_recoil_max = {0.05, 0.05, 0.05, 0.05, 0.05},
        vertical_recoil_correct = {0.02, 0.02, 0.02, 0.02, 0.02},
        horizontal_recoil = {0.01, 0.01, 0.01, 0.01, 0.01},
        horizontal_recoil_max = {0.05, 0.05, 0.05, 0.05, 0.05},
        horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
        recoil_cooling_time = {350, 350, 350, 350, 250},
        vertical_recoil_proportion = 0.2,
        horizontal_recoil_proportion = 0.2,
        -- 弹道参数
        change_probability = {20, 120},
        spread_radius = {0, 0, 0, 0, 0},
        spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
        spread_range = {360, 360, 360, 360, 120},
        spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
        spread_range_correct = {0, 0, 0, 0, 0},
        spread_cooling_time = 2380.000000,
        offset_distance = {3, 3, 3, 3.3, 2},
        return_time = 90,
        -- 弹丸参数
        muzzle_velocity = 5800.000000,
        gun_repel = 0.000000,
        pill_num = 1.000000,
        --bullet_pattern = {},

        -- 首次开火延迟
        fire_delay = 0.000000,
        --mode_data = {0},

        -- 自动扳机
        auto_fire_dis = 0.000000,
        -- 辅助瞄准
        auto_aim_dis = 0.000000,
        -- 第三人称控制器
        tps_controller = "",
        tps_hanging_point = "101"
    },
    ["MGPeaShooter"] = {
        -- 武器类型
        gun_type = 5,
        shooting_mode = {3, 1},
        -- 植物资源
        plant_res = "",
        plant_icon1 = "",
        plant_icon2 = "",
        -- 武器参数

        --射击频率(毫秒/发)
        fire_rate = 80,
        --装弹参数
        reload_type = 1.000000,
        reload_time = 1500.000000,
        -- 伤害参数
        attack_max = 45.000000,
        damage_head = 28.000000,
        damage_body = 23.000000,
        -- damage_hand = 45.000000,
        -- damage_leg = 45.000000,
        -- damage_foot = 45.000000,

        --伤害衰减
        attenuation_distance_body = 45.000000,
        attack_min_body = 8.000000,
        attenuation_distance_head = 30.000000,
        attack_min_head = 19.000000,
        attack_through = 0.200000,
        -- 最大射程
        max_range = 300.000000,
        -- 弹夹参数
        magazine = 50.000000,
        magazine_carry = 99999.000000,
        --speed_influence = 0.7,

        --开火动作后等待时间
        FireAction_time = 0.000000,
        --准星
        crossHair_mode = 1.000000,
        HIP_crossHair = "role/1001",
        -- sight_crossHair = "role/2001",
        -- ADS_FOV = 50.000000,
        -- ADS_speed = 0.700000,
        -- ADS_sensitivity = 0.300000,

        -- 后座力参数
        vertical_recoil = {0.01, 0.01, 0.01, 0.01, 0.01},
        vertical_recoil_max = {0.05, 0.05, 0.05, 0.05, 0.05},
        vertical_recoil_correct = {0.02, 0.02, 0.02, 0.02, 0.02},
        horizontal_recoil = {0.01, 0.01, 0.01, 0.01, 0.01},
        horizontal_recoil_max = {0.05, 0.05, 0.05, 0.05, 0.05},
        horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
        recoil_cooling_time = {350, 350, 350, 350, 250},
        vertical_recoil_proportion = 0.2,
        horizontal_recoil_proportion = 0.2,
        -- 弹道参数
        change_probability = {20, 120},
        spread_radius = {0, 0, 0, 0, 0},
        spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
        spread_range = {360, 360, 360, 360, 120},
        spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
        spread_range_correct = {0, 0, 0, 0, 0},
        spread_cooling_time = 2380.000000,
        offset_distance = {3, 3, 3, 3.3, 2},
        return_time = 90,
        -- 弹丸参数
        muzzle_velocity = 5000.000000,
        gun_repel = 0.000000,
        Bullet_type = 1.000000,
        pill_num = 1.000000,
        --bullet_pattern = {},

        -- 首次开火延迟
        fire_delay = 0.000000,
        --mode_data = {0},

        -- 自动扳机
        auto_fire_dis = 0.000000,
        -- 辅助瞄准
        auto_aim_dis = 0.000000,
        -- 第三人称控制器
        tps_controller = "",
        tps_hanging_point = "101"
    },
    ["SnowPeaShooter"] = {
        -- 武器类型
        gun_type = 5,
        gun_name = "PeaShooter",
        shooting_mode = {3, 1},
        -- 植物资源
        plant_res = "",
        plant_icon1 = "",
        plant_icon2 = "",
        -- 武器参数

        --射击频率(毫秒/发)
        fire_rate = 380,
        --装弹参数
        reload_type = 1.000000,
        reload_time = 1500.000000,
        -- 伤害参数
        attack_max = 45.000000,
        damage_head = 28.000000,
        damage_body = 23.000000,
        -- damage_hand = 45.000000,
        -- damage_leg = 45.000000,
        -- damage_foot = 45.000000,

        --伤害衰减
        attenuation_distance_body = 45.000000,
        attack_min_body = 8.000000,
        attenuation_distance_head = 30.000000,
        attack_min_head = 19.000000,
        attack_through = 0.200000,
        -- 最大射程
        max_range = 300.000000,
        -- 弹夹参数
        magazine = 10.000000,
        magazine_carry = 60.000000,
        --speed_influence = 0.7,

        --开火动作后等待时间
        FireAction_time = 0.000000,
        --准星
        crossHair_mode = 1.000000,
        HIP_crossHair = "role/1001",
        -- sight_crossHair = "role/2001",
        -- ADS_FOV = 50.000000,
        -- ADS_speed = 0.700000,
        -- ADS_sensitivity = 0.300000,

        -- 后座力参数
        vertical_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        vertical_recoil_max = {0.13, 0.13, 0.13, 0.13, 0.13},
        vertical_recoil_correct = {0.13, 0.13, 0.13, 0.13, 0.13},
        horizontal_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        horizontal_recoil_max = {0.1, 0.1, 0.1, 0.1, 0.1},
        horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
        recoil_cooling_time = {350, 350, 350, 350, 250},
        vertical_recoil_proportion = 0.2,
        horizontal_recoil_proportion = 0.2,
        -- 弹道参数
        change_probability = {20, 120},
        spread_radius = {0, 0, 0, 0, 0},
        spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
        spread_range = {360, 360, 360, 360, 120},
        spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
        spread_range_correct = {0, 0, 0, 0, 0},
        spread_cooling_time = 2380.000000,
        offset_distance = {3, 3, 3, 3.3, 2},
        return_time = 90,
        -- 弹丸参数
        muzzle_velocity = 6200.000000,
        gun_repel = 0.000000,
        Bullet_type = 1.000000,
        pill_num = 1.000000,
        --bullet_pattern = {},

        -- 首次开火延迟
        fire_delay = 0.000000,
        --mode_data = {0},

        -- 自动扳机
        auto_fire_dis = 0.000000,
        -- 辅助瞄准
        auto_aim_dis = 0.000000,
        -- 第三人称控制器
        tps_controller = "",
        tps_hanging_point = "101"
    },
    ["FumeShroom"] = {
        -- 武器类型
        gun_type = 5,
        gun_name = "PeaShooter",
        shooting_mode = {3, 1},
        -- 植物资源
        plant_res = "",
        plant_icon1 = "",
        plant_icon2 = "",
        -- 武器参数

        --射击频率(毫秒/发)
        fire_rate = 3000,
        --装弹参数
        reload_type = 1.000000,
        reload_time = 2800.000000,
        -- 伤害参数
        attack_max = 45.000000,
        damage_head = 28.000000,
        damage_body = 23.000000,
        -- damage_hand = 45.000000,
        -- damage_leg = 45.000000,
        -- damage_foot = 45.000000,

        --伤害衰减
        attenuation_distance_body = 45.000000,
        attack_min_body = 8.000000,
        attenuation_distance_head = 30.000000,
        attack_min_head = 19.000000,
        -- 穿透
        attack_through = 0.200000,
        -- 最大射程
        max_range = 300.000000,
        -- 弹夹参数
        magazine = 1.000000,
        magazine_carry = 99.000000,
        --speed_influence = 0.7,

        --开火动作后等待时间
        FireAction_time = 0.000000,
        --准星
        crossHair_mode = 1.000000,
        HIP_crossHair = "role/1001",
        -- sight_crossHair = "role/2001",
        -- ADS_FOV = 50.000000,
        -- ADS_speed = 0.700000,
        -- ADS_sensitivity = 0.300000,

        -- 后座力参数
        vertical_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        vertical_recoil_max = {0.13, 0.13, 0.13, 0.13, 0.13},
        vertical_recoil_correct = {0.13, 0.13, 0.13, 0.13, 0.13},
        horizontal_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        horizontal_recoil_max = {0.1, 0.1, 0.1, 0.1, 0.1},
        horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
        recoil_cooling_time = {350, 350, 350, 350, 250},
        vertical_recoil_proportion = 0.2,
        horizontal_recoil_proportion = 0.2,
        -- 弹道参数
        change_probability = {20, 120},
        spread_radius = {0, 0, 0, 0, 0},
        spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
        spread_range = {360, 360, 360, 360, 120},
        spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
        spread_range_correct = {0, 0, 0, 0, 0},
        spread_cooling_time = 2380.000000,
        offset_distance = {3, 3, 3, 3.3, 2},
        return_time = 90,
        -- 弹丸参数
        muzzle_velocity = 2000.000000,
        gun_repel = 0.000000,
        Bullet_type = 1.000000,
        pill_num = 1.000000,
        --bullet_pattern = {},

        -- 首次开火延迟
        fire_delay = 0.000000,
        --mode_data = {0},

        -- 自动扳机
        auto_fire_dis = 0.000000,
        -- 辅助瞄准
        auto_aim_dis = 0.000000,
        -- 第三人称控制器
        tps_controller = "",
        tps_hanging_point = "101"
    },
    ["SplitPeaShooter"] = {
        -- 武器类型
        gun_type = 5,
        shooting_mode = {3, 1},
        -- 植物资源
        plant_res = "",
        plant_icon1 = "",
        plant_icon2 = "",
        -- 武器参数

        --射击频率(毫秒/发)
        fire_rate = 1000,
        --装弹参数
        reload_type = 1.000000,
        reload_time = 1500.000000,
        -- 伤害参数
        attack_max = 45.000000,
        damage_head = 28.000000,
        damage_body = 23.000000,
        -- damage_hand = 45.000000,
        -- damage_leg = 45.000000,
        -- damage_foot = 45.000000,

        --伤害衰减
        attenuation_distance_body = 45.000000,
        attack_min_body = 8.000000,
        attenuation_distance_head = 30.000000,
        attack_min_head = 19.000000,
        attack_through = 0.200000,
        -- 最大射程
        max_range = 300.000000,
        -- 弹夹参数
        magazine = 10.000000,
        magazine_carry = 99999.000000,
        --speed_influence = 0.7,

        --开火动作后等待时间
        FireAction_time = 0.000000,
        --准星
        crossHair_mode = 1.000000,
        HIP_crossHair = "role/1001",
        -- sight_crossHair = "role/2001",
        -- ADS_FOV = 50.000000,
        -- ADS_speed = 0.700000,
        -- ADS_sensitivity = 0.300000,

        -- 后座力参数
        vertical_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        vertical_recoil_max = {0.13, 0.13, 0.13, 0.13, 0.13},
        vertical_recoil_correct = {0.13, 0.13, 0.13, 0.13, 0.13},
        horizontal_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
        horizontal_recoil_max = {0.1, 0.1, 0.1, 0.1, 0.1},
        horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
        recoil_cooling_time = {350, 350, 350, 350, 250},
        vertical_recoil_proportion = 0.2,
        horizontal_recoil_proportion = 0.2,
        -- 弹道参数
        change_probability = {20, 120},
        spread_radius = {0, 0, 0, 0, 0},
        spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
        spread_range = {360, 360, 360, 360, 120},
        spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
        spread_range_correct = {0, 0, 0, 0, 0},
        spread_cooling_time = 2380.000000,
        offset_distance = {3, 3, 3, 3.3, 2},
        return_time = 90,
        -- 弹丸参数
        muzzle_velocity = 6200.000000,
        gun_repel = 0.000000,
        Bullet_type = 1.000000,
        pill_num = 1.000000,
        --bullet_pattern = {},

        -- 首次开火延迟
        fire_delay = 0.000000,
        --mode_data = {0},

        -- 自动扳机
        auto_fire_dis = 0.000000,
        -- 辅助瞄准
        auto_aim_dis = 0.000000,
        -- 第三人称控制器
        tps_controller = "",
        tps_hanging_point = "101"
    }
    -- ["ThreePeaShooter"] = {
    --     -- 武器类型
    --     gun_type = 5,
    --     gun_name = "ThreePeaShooter",
    --     shooting_mode = {3, 1},
    --     -- 植物资源
    --     plant_res = "",
    --     plant_icon1 = "",
    --     plant_icon2 = "",
    --     -- 武器参数

    --     --射击频率(毫秒/发)
    --     fire_rate = 380,
    --     --装弹参数
    --     reload_type = 1.000000,
    --     reload_time = 1500.000000,
    --     -- 伤害参数
    --     attack_max = 45.000000,
    --     damage_head = 28.000000,
    --     damage_body = 23.000000,
    --     -- damage_hand = 45.000000,
    --     -- damage_leg = 45.000000,
    --     -- damage_foot = 45.000000,

    --     --伤害衰减
    --     attenuation_distance_body = 45.000000,
    --     attack_min_body = 8.000000,
    --     attenuation_distance_head = 30.000000,
    --     attack_min_head = 19.000000,
    --     attack_through = 0.200000,
    --     -- 最大射程
    --     max_range = 300.000000,
    --     -- 弹夹参数
    --     magazine = 10.000000,
    --     magazine_carry = 60.000000,
    --     --speed_influence = 0.7,

    --     --开火动作后等待时间
    --     FireAction_time = 0.000000,
    --     --准星
    --     crossHair_mode = 1.000000,
    --     HIP_crossHair = "role/1001",
    --     -- sight_crossHair = "role/2001",
    --     -- ADS_FOV = 50.000000,
    --     -- ADS_speed = 0.700000,
    --     -- ADS_sensitivity = 0.300000,

    --     -- 后座力参数
    --     vertical_recoil = {0.1, 0.1, 0.1, 0.1, 0.1},
    --     vertical_recoil_max = {0.13, 0.13, 0.13, 0.13, 0.13},
    --     vertical_recoil_correct = {0.13, 0.13, 0.13, 0.13, 0.13},
    --     horizontal_recoil = {0.05, 0.05, 0.05, 0.05, 0.05},
    --     horizontal_recoil_max = {0.1, 0.1, 0.1, 0.1, 0.1},
    --     horizontal_recoil_correct = {0.01, 0.01, 0.01, 0.01, 0.01},
    --     recoil_cooling_time = {350, 350, 350, 350, 250},
    --     vertical_recoil_proportion = 0.2,
    --     horizontal_recoil_proportion = 0.2,
    --     -- 弹道参数
    --     change_probability = {20, 120},
    --     spread_radius = {0, 0, 0, 0, 0},
    --     spread_max = {0.54, 0.54, 0.54, 0.594, 0.54},
    --     spread_range = {360, 360, 360, 360, 120},
    --     spread_radius_correct = {0.106, 0.106, 0.106, 0.106, 0.106},
    --     spread_range_correct = {0, 0, 0, 0, 0},
    --     spread_cooling_time = 2380.000000,
    --     offset_distance = {3, 3, 3, 3.3, 2},
    --     return_time = 90,
    --     -- 弹丸参数
    --     muzzle_velocity = 6200.000000,
    --     gun_repel = 0.000000,
    --     Bullet_type = 1.000000,
    --     pill_num = 1.000000,
    --     --bullet_pattern = {},

    --     -- 首次开火延迟
    --     fire_delay = 0.000000,
    --     --mode_data = {0},

    --     -- 自动扳机
    --     auto_fire_dis = 0.000000,
    --     -- 辅助瞄准
    --     auto_aim_dis = 0.000000,
    --     -- 第三人称控制器
    --     tps_controller = "",
    --     tps_hanging_point = "101"
    -- }
}

return Config_weaponPlant
