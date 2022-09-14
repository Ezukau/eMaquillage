ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent("eMaquillage:use")
AddEventHandler("eMaquillage:use", function()
	OpenMenu() 
end)

LipsListe = {"Aucun"}
for i = 1, 10, 1 do
    table.insert(LipsListe,  "~"..Config.CouleurMenu.."~"..GetLabelText("CC_LIPSTICK_" .. i - 1).."~s~")
end
BlushListe = {"Aucun"}
for i = 1, 10, 1 do
    table.insert(BlushListe, "~"..Config.CouleurMenu.."~"..GetLabelText("CC_BLUSH_" .. i - 1).."~s~")
end

local Main = RageUI.CreateMenu("Maquillage", "Interaction", nil, nil, 'root_cause5', "img_violet")
local open = false
Main.Display.Header = true
Main.Closed = function()
    open = false
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(0, true, 2000)
    DestroyAllCams(true)

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end
Main.EnableMouse = true

local RougeLevre = {
	Opacite = 0,
	Color = {1, 1},
    Index = 1
}

local Blush = {
	Opacite = 0,
	Color = {1, 1},
    Index = 1
}

function Cam()   
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x+1.25, coords.y+1.25, coords.z+0.50)
    SetCamFov(cam, 15.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z+0.65)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

ControlDisable = {20, 24, 27, 178, 177, 189, 190, 187, 188, 202, 239, 240, 201, 172, 173, 174, 175}
function OnRenderCam() 
    local Control1, Control2 = IsDisabledControlPressed(1, 44), IsDisabledControlPressed(1, 51)
    if Control1 or Control2 then
        local pPed = PlayerPedId()
        SetEntityHeading(pPed, Control1 and GetEntityHeading(pPed) - 2.0 or Control2 and GetEntityHeading(pPed) + 2.0)
    end
end

function OpenMenu() 
    if open then 
		open = false
		RageUI.Visible(Main, false)
		return
	else
		open = true 
		RageUI.Visible(Main, true)
		Cam()
		FreezeEntityPosition(PlayerPedId(), true)
		CreateThread(function()
		while open do 

        RageUI.IsVisible(Main, function()
            
			RageUI.List("~"..Config.CouleurMenu.."~→~s~ Rouge a lèvre",LipsListe, RougeLevre.Index,nil,{},true,{

                onActive = function()
                    OnRenderCam() 
                end,

                onListChange = function(Index, Item)
                    RougeLevre.Index = Index
                    TriggerEvent("skinchanger:change", "lipstick_1", RougeLevre.Index)
                end,

				onSelected = function()
					RenderScriptCams(0, true, 2000)
					DestroyAllCams(true)
					FreezeEntityPosition(PlayerPedId(), false)
                    RageUI.CloseAll()

                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_skin:save', skin)
                    end)

				end,
            })
			            
			RageUI.List("~"..Config.CouleurMenu.."~→~s~ Blush", BlushListe, Blush.Index,nil,{},true,{

                onActive = function()
                    OnRenderCam() 
                end,

                onListChange = function(Index, Item)
                    Blush.Index = Index
                    TriggerEvent("skinchanger:change", "blush_1", Blush.Index)
                end,

				onSelected = function()
					RenderScriptCams(0, true, 2000)
					DestroyAllCams(true)
					FreezeEntityPosition(PlayerPedId(), false)
                    RageUI.CloseAll()

                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_skin:save', skin)
                    end)
                    
				end,
            })

			RageUI.PercentagePanel(RougeLevre.Opacite, 'Opacité', '0%', '100%', {
                onProgressChange = function(Percentage)
                    RougeLevre.Opacite = Percentage
                    TriggerEvent('skinchanger:change', 'lipstick_2',Percentage*10)
                end
            }, 1) 

            RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.HairCut,  RougeLevre.Color[1],  RougeLevre.Color[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    RougeLevre.Color[1] = MinimumIndex
                    RougeLevre.Color[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "lipstick_3",  RougeLevre.Color[2])
                end
            }, 1)

			RageUI.PercentagePanel(Blush.Opacite, 'Opacité', '0%', '100%', {
                onProgressChange = function(Percentage)
                    Blush.Opacite = Percentage
                    TriggerEvent('skinchanger:change', 'blush_2',Percentage*10)
                end
            }, 2) 

            RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.HairCut,  Blush.Color[1],  Blush.Color[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    Blush.Color[1] = MinimumIndex
                    Blush.Color[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "blush_3",  Blush.Color[2])
                end
            }, 2)

        end)
        Wait(0)
    end
    end)
    end
end







