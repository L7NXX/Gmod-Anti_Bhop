-- Author: L7NX
-- Creation Date: 3/24/24
-- Version: 1.0

if SERVER then
    
    local maxHops = 1 -- Adjust this as needed
    --local messageCount = 0 

    -- Hook player's movement
    hook.Add("SetupMove", "AntiHopMoveLimit", function(ply, move)
        -- Check if the player has exceeded the maximum bunny hops
        if ply.hopCount and ply.hopCount > maxHops then
            local currSpeed = ply:GetVelocity():Length2D()
            if currSpeed > ply:GetRunSpeed() then
                --messageCount = messageCount + 1 -- Increment message counter
                --ply:SendLua("chat.AddText(Color(255, 0, 0), '".. messageCount .. ". No bhopping allowed! ')")
                local newVel = ply:GetVelocity()
                newVel:Mul(0.5) -- Reduce player's air velocity by half
                ply:SetVelocity(newVel - ply:GetVelocity()) -- Subtract current velocity
            end
        end

        -- Check how long the player has been on the ground
        if ply:IsOnGround() then
            if not ply.landTime then
                ply.landTime = CurTime() -- Record time when player lands
            else
                local timeOnGround = CurTime() - ply.landTime
                if timeOnGround > 0.1 then
                    ply.hopCount = 0 -- Reset bhop count
                end
            end
        else
            ply.landTime = nil -- Reset landing time when player is in the air
        end
    end)

    -- Hook player's landing
    hook.Add("PlayerFootstep", "AntiHopOnLand", function(ply, pos, foot, sound, volume, rf)
        if not ply.hopCount then
            ply.hopCount = 1
        else
            ply.hopCount = ply.hopCount + 1
        end
    end)

    MsgC(Color(0, 255, 0), "\n\n\n" .. [[

     █████╗ ███╗   ██╗████████╗██╗      ██████╗ ██╗  ██╗ ██████╗ ██████╗     ██╗   ██╗ ██╗    ██████╗ 
    ██╔══██╗████╗  ██║╚══██╔══╝██║      ██╔══██╗██║  ██║██╔═══██╗██╔══██╗    ██║   ██║███║   ██╔═████╗
    ███████║██╔██╗ ██║   ██║   ██║█████╗██████╔╝███████║██║   ██║██████╔╝    ██║   ██║╚██║   ██║██╔██║
    ██╔══██║██║╚██╗██║   ██║   ██║╚════╝██╔══██╗██╔══██║██║   ██║██╔═══╝     ╚██╗ ██╔╝ ██║   ████╔╝██║
    ██║  ██║██║ ╚████║   ██║   ██║      ██████╔╝██║  ██║╚██████╔╝██║          ╚████╔╝  ██║██╗╚██████╔╝
    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝           ╚═══╝   ╚═╝╚═╝ ╚═════╝                                                               
                                        Loaded Successfully!

    ]] .. "\n\n\n")
end