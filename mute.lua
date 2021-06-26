--- This script adds the ability to mute/unmute a sound source when specific scenes are activated/deactivated
--- Up to 10 scenes can be selected and one audio source.
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

scene1 = ""
scene2 = ""
scene3 = ""
scene4 = ""
scene5 = ""
scene6 = ""
scene7 = ""
scene8 = ""
scene9 = ""
scene10 = ""

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

        -- enable mute when transitioning into one of the scenes
        if scene_name == scene1 or scene_name == scene2 or scene_name == scene3 or scene_name == scene4 or scene_name == scene5 or scene_name == scene6 or scene_name == scene7 or scene_name == scene8 or scene_name == scene9 or scene_name == scene10 then
            obs.obs_source_set_muted(actual_source, true)

        -- disable mute when transitioning away from one of the scenes
        elseif last_scene == scene1 or last_scene == scene2 or last_scene == scene3 or last_scene == scene4 or last_scene == scene5 or last_scene == scene6 or last_scene == scene7 or last_scene == scene8 or last_scene == scene9 or last_scene == scene10 then
            obs.obs_source_set_muted(actual_source, false)
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
    local scene1 = obs.obs_properties_add_list(props, "scene1", "Mute Scene 1", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene2 = obs.obs_properties_add_list(props, "scene2", "Mute Scene 2", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene3 = obs.obs_properties_add_list(props, "scene3", "Mute Scene 3", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene4 = obs.obs_properties_add_list(props, "scene4", "Mute Scene 4", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene5 = obs.obs_properties_add_list(props, "scene5", "Mute Scene 5", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene6 = obs.obs_properties_add_list(props, "scene6", "Mute Scene 6", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene7 = obs.obs_properties_add_list(props, "scene7", "Mute Scene 7", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene8 = obs.obs_properties_add_list(props, "scene8", "Mute Scene 8", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene9 = obs.obs_properties_add_list(props, "scene9", "Mute Scene 9", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local scene10 = obs.obs_properties_add_list(props, "scene10", "Mute Scene 10", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)

    local scenes = obs.obs_frontend_get_scenes()
    if scenes ~= nil then
        for _, scene in ipairs(scenes) do
            local name = obs.obs_source_get_name(scene);
            obs.obs_property_list_add_string(scene1, name, name)
            obs.obs_property_list_add_string(scene2, name, name)
            obs.obs_property_list_add_string(scene3, name, name)
            obs.obs_property_list_add_string(scene4, name, name)
            obs.obs_property_list_add_string(scene5, name, name)
            obs.obs_property_list_add_string(scene6, name, name)
            obs.obs_property_list_add_string(scene7, name, name)
            obs.obs_property_list_add_string(scene8, name, name)
            obs.obs_property_list_add_string(scene9, name, name)
            obs.obs_property_list_add_string(scene10, name, name)
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
    scene1 = obs.obs_data_get_string(settings, "scene1")
    scene2 = obs.obs_data_get_string(settings, "scene2")
    scene3 = obs.obs_data_get_string(settings, "scene3")
    scene4 = obs.obs_data_get_string(settings, "scene4")
    scene5 = obs.obs_data_get_string(settings, "scene5")
    scene6 = obs.obs_data_get_string(settings, "scene6")
    scene7 = obs.obs_data_get_string(settings, "scene7")
    scene8 = obs.obs_data_get_string(settings, "scene8")
    scene9 = obs.obs_data_get_string(settings, "scene9")
    scene10 = obs.obs_data_get_string(settings, "scene10")

    source_name = obs.obs_data_get_string(settings, "source")
end

-- register an event callback
function script_load(settings)
    obs.obs_frontend_add_event_callback(on_event)
end
