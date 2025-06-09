--[[
    Speed Limiter Script
    Author: Liam Colson - Policing London
    Description: Allows players to limit the speed of their current vehicle using a chat command.
]]

local limiterActive = false
local currentLimit = nil

RegisterCommand("limiter", function(source, args)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        TriggerEvent('chat:addMessage', {
            args = {"^1[SpeedLimiter]^0 You must be the driver of a vehicle."}
        })
        return
    end

    local arg = args[1]

    if not arg then
        TriggerEvent('chat:addMessage', {
            args = {"^1[SpeedLimiter]^0 Usage: /limiter [speed in MPH] or /limiter off"}
        })
        return
    end

    if arg == "off" then
        SetVehicleMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
        limiterActive = false
        currentLimit = nil
        TriggerEvent('chat:addMessage', {
            args = {"^2[SpeedLimiter]^0 Speed limiter disabled."}
        })
        return
    end

    local speed = tonumber(arg)
    if not speed or speed <= 0 then
        TriggerEvent('chat:addMessage', {
            args = {"^1[SpeedLimiter]^0 Invalid speed. Must be a number above 0."}
        })
        return
    end

    -- Convert MPH to m/s (1 mph = 0.44704 m/s)
    local speedLimit = speed * 0.44704

    SetVehicleMaxSpeed(vehicle, speedLimit)
    limiterActive = true
    currentLimit = speedLimit

    TriggerEvent('chat:addMessage', {
        args = {"^2[SpeedLimiter]^0 Speed limiter set to " .. speed .. " MPH."}
    })
end)
