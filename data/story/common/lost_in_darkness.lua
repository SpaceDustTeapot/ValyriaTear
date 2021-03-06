local ns = {}
setmetatable(ns, {__index = _G})
lost_in_darkness = ns;
setfenv(1, ns);

local Script = nil
local instance = nil
local darkness_layer = nil

-- Oil animation
local oil_lamp = nil
local lamp_halo = nil
local lamp_flare = nil
local lamp_halo_visibility = nil

local darkness_color = vt_video.Color(0.0, 0.0, 0.0, 0.8)

-- add a evening light layer
function Initialize(m)
    instance = m
    Script = instance:GetScriptSupervisor()

    -- Load a white empty image
    darkness_layer = Script:CreateImage("");
    darkness_layer:SetDimensions(1024.0, 768.0)

    oil_lamp = Script:CreateAnimation("data/battles/battle_scenes/oil_lamp.lua")

    lamp_halo = Script:CreateAnimation("data/visuals/lights/torch_light_mask2.lua")
    lamp_halo:SetDimensions(340.0, 340.0)
    lamp_flare = Script:CreateImage("data/visuals/lights/sun_flare_light.png")
    lamp_flare:SetDimensions(154.0, 161.0)
    lamp_halo_visibility = Script:CreateAnimation("data/visuals/lights/torch_light_mask.lua")
    lamp_halo_visibility:SetDimensions(1200.0, 1200.0)

    -- In map mode, make it slightly less eye hurting
    if (ModeManager:GetGameType() == vt_mode_manager.GameModeManager.MODE_MANAGER_MAP_MODE) then
        darkness_color = vt_video.Color(0.0, 0.0, 0.0, 0.7)
    end
end

function Update()
    -- Get time expired
    local time_expired = SystemManager:GetUpdateTime()

    -- Update fire animation
    lamp_halo:Update(time_expired)
end

local lamp_halo_color = vt_video.Color(0.9, 0.9, 0.4, 0.5)
local lamp_flare_color = vt_video.Color(0.99, 1.0, 0.27, 0.2)
local white_color = vt_video.Color(1.0, 1.0, 1.0, 1.0)

local oil_lamp_x = 100.0
local oil_lamp_y = 530.0

function DrawForeground()
    -- Useful for the map mode
    Script:SetDrawFlag(vt_video.GameVideo.VIDEO_X_LEFT)
    Script:SetDrawFlag(vt_video.GameVideo.VIDEO_Y_TOP)

    -- Only draw the oil lamp in battle game mode
    if (ModeManager:GetGameType() == vt_mode_manager.GameModeManager.MODE_MANAGER_BATTLE_MODE) then
        VideoManager:Move(oil_lamp_x, oil_lamp_y)
        oil_lamp:Draw(white_color)
    end

        VideoManager:Move(0.0, 0.0)
        darkness_layer:Draw(darkness_color)

    -- Only draw the special light in battle mode
    if (ModeManager:GetGameType() == vt_mode_manager.GameModeManager.MODE_MANAGER_BATTLE_MODE) then
        Script:SetDrawFlag(vt_video.GameVideo.VIDEO_BLEND_ADD)
        VideoManager:Move(oil_lamp_x - 143, oil_lamp_y - 115);
        lamp_halo:Draw(lamp_halo_color);
        VideoManager:Move(oil_lamp_x - 143, oil_lamp_y - 400);
        lamp_halo_visibility:Draw(lamp_halo_color);
        VideoManager:Move(oil_lamp_x - 57, oil_lamp_y - 41);
        lamp_flare:Draw(lamp_flare_color);
        Script:SetDrawFlag(vt_video.GameVideo.VIDEO_BLEND)
    end
end
