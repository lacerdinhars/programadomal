-- NINJA V27 – MANUAL AIM MAGNET (PRECISION MODE)
-- Só gruda quando VOCÊ leva a mira até a cabeça

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURAÇÃO
local RaioAtivacao = 4        -- raio bem pequeno (quanto menor, mais preciso)
local Suavidade = 0.25        -- força do magnet (baixo = mais legit)
local IntencaoMinima = 0.85   -- quão direto você precisa ir na cabeça

-- FUNÇÃO PARA PEGAR O ALVO (CABEÇA)
local function GetTarget()
    local alvo = nil
    local menorDist = RaioAtivacao

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer
        and p.Team ~= LocalPlayer.Team
        and p.Character
        and p.Character:FindFirstChild("Head")
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0 then

            local head = p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude

                if dist < menorDist then
                    menorDist = dist
                    alvo = pos
                end
            end
        end
    end

    return alvo
end

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    local mouseDelta = UserInputService:GetMouseDelta()

    -- Se você NÃO estiver mexendo o mouse, não faz nada
    if math.abs(mouseDelta.X) < 0.5 and math.abs(mouseDelta.Y) < 0.5 then
        return
    end

    local alvo = GetTarget()
    if not alvo then return end

    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local toTarget = Vector2.new(alvo.X, alvo.Y) - mousePos
    local dist = toTarget.Magnitude

    if dist > RaioAtivacao then return end

    -- TESTE DE INTENÇÃO (ESSENCIAL)
    local moveDir = Vector2.new(mouseDelta.X, mouseDelta.Y).Unit
    local targetDir = toTarget.Unit
    local intencao = moveDir:Dot(targetDir)

    -- Se você não estiver indo EM DIREÇÃO à cabeça, não gruda
    if intencao < IntencaoMinima then return end

    -- Força cresce conforme chega mais perto
    local força = (1 - (dist / RaioAtivacao)) * Suavidade

    if mousemoverel then
        mousemoverel(toTarget.X * força, toTarget.Y * força)
    end
end)

-- ESP TOGGLE (V)
local espOn = false
Mouse.KeyDown:Connect(function(k)
    if k:lower() == "v" then
        espOn = not espOn
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("V27") or Instance.new("Highlight")
                h.Name = "V27"
                h.Parent = p.Character
                h.Enabled = espOn
                h.FillTransparency = 1
                h.OutlineColor = (p.Team == LocalPlayer.Team)
                    and Color3.fromRGB(0,255,0)
                    or Color3.fromRGB(255,0,0)
            end
        end
    end
end)
