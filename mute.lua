--- This script adds the ability to mute/unmute a sound source when specific scenes are activated/deactivated
--- up to all your scenes can be selected and one audio source.
---
--- Usage:
---  Download this script to a safe location on your OBS PC
---  In OBS go to Tools >> Scripts
---  Choose this script
---  Choose the audio source which should be muted/umuted
---  Choose on or more scenes which should trigger the muting/unmuting when those are transitioned to/from
---
---  If the scene or audio source is not listed on the script settings page, press the refresh button.

obs = obslua
scenes_qty = obs.obs_frontend_get_scenes()  -- sets the amount of scenes availables

scenes_menu = {}    -- new array
for i=1, #scenes_qty do
    scenes_menu[i] = ""
end

last_scene = ""
source_name = ""

-- Log function for debugging
function script_log(message)
    obs.script_log(obs.LOG_INFO, message)
end

-- Given a source name, get the source object
function get_source_by_name(source_name)
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            local name = obs.obs_source_get_name(source)
            if name == source_name then
                return source
            end
        end
    end
end

-- Respond to the on_event - scene_changed trigger
function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local scene = obs.obs_frontend_get_current_scene()
        local scene_name = obs.obs_source_get_name(scene)
        local actual_source = get_source_by_name(source_name)
        local aux = false

        
        for i=1, #scenes_qty do
           if scenes_menu[i] == scene_name then
                
        -- enable mute when transitioning into one of the scenes
                obs.obs_source_set_muted(actual_source, true)
            elseif scenes_menu[i] == last_scene then
        
        -- disable mute when transitioning away from one of the scenes
                obs.obs_source_set_muted(actual_source, false)
                end
        end

        last_scene = scene_name -- keep track of the last scene
        obs.obs_source_release(scene)
        obs.obs_source_release(actual_source)
    end
end

-- Script properties (Script settings page)
function script_properties()
    local props = obs.obs_properties_create()

    -- Audio source
    local p = obs.obs_properties_add_list(props, "source", "Audio Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            source_id = obs.obs_source_get_unversioned_id(source)
            if source_id == "wasapi_input_capture" or source_id == "wasapi_output_capture" then
                local name = obs.obs_source_get_name(source)
                obs.obs_property_list_add_string(p, name, name)
            end
        end
    end
    obs.source_list_release(sources)

    -- Scenes
    local scenes_menu = {}    -- new array
    for i=1, #scenes_qty do
        scenes_menu[i] = obs.obs_properties_add_list(props, "scene" .. i, "Mute Scene " .. i, obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    end
    
    local scenes = obs.obs_frontend_get_scenes()
    if scenes ~= nil then
        for _, scene in ipairs(scenes) do
            local name = obs.obs_source_get_name(scene);
            
            for i=1, #scenes_qty do
                obs.obs_property_list_add_string(scenes_menu[i], name, name)
            end           
        end
    end
    obs.source_list_release(scenes)

    return props
end


-- Script description which shows on the script settings page
function script_description()
    return "Adds the ability to mute/unmute a sound source when specific scenes are activated/deactivated"
end

-- Respond to the script_update hook
-- Load the properties into memory.
function script_update(settings)
    for i=1, #scenes_qty do
        scenes_menu[i] = obs.obs_data_get_string(settings, "scene" .. i)
    end
    
    source_name = obs.obs_data_get_string(settings, "source")
end

-- register an event callback
function script_load(settings)
    obs.obs_frontend_add_event_callback(on_event)
end
