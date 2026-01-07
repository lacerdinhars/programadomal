-- NINJA V29 (LEFT-CLICK TRIGGER AIMBOT)
-- SÓ PUXA PARA A CABEÇA QUANDO VOCÊ ATIRA

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURAÇÕES DE AIMBOT AGRESSIVO
local Suavidade = 0.3 -- Velocidade do "bote" ao clicar
local FOV_Raio = 120 -- Área de detecção ao redor da mira
local Atirando = false

-- GATILHO: BOTÃO ESQUERDO (MOUSE BUTTON 1)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Atirando = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Atirando = false
    end
end)

local function GetTarget()
    local target = nil
    local shortestDist = FOV_Raio

    for _, p in pairs(Players:GetPlayers()) do
        -- Filtro rigoroso: Inimigo, Vivo, Na Tela
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude

                if dist < shortestDist then
                    target = pos
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- O AIMBOT SÓ "LIGA" QUANDO VOCÊ CLICA PARA ATIRAR
    if Atirando then
        local t = GetTarget()
        if t then
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            -- Movimento de correção instantânea
            local diffX = (t.X - mousePos.X) * Suavidade
            local diffY = (t.Y - mousePos.Y) * Suavidade
            
            if mousemoverel then
                mousemoverel(diffX, diffY)
            end
        end
    end
end)

-- ESP (Tecla V)
local espOn = false
Mouse.KeyDown:Connect(function(k)
    if key == "v" then
        espOn = not espOn
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.Enabled = espOn
                h.FillTransparency = 1
                h.OutlineColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            end
        end
    end
end)
