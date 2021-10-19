_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Main Menu", "~b~Menu test description")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled (false)
_menuPool:MouseEdgeEnabled (false)
_menuPool:ControlDisablingEnabled(false)

-- voor "FirstMenu"
bool = false

-- dit is de checkbox
function FirstItem(menu)
local checkbox = NativeUI.CreateCheckboxItem("Click me", bool, "Toggle this item")
menu:AddItem(checkbox)
menu.OnCheckboxChange = function (sender, item, checked_)
  if item == checkbox then
    bool = checked_
    --[[ Output voor checkbox ]]
    notify(tostring(bool))
  end
end
end

function SecondItem(menu)
local click = NativeUI.CreateItem("Heal me", "~g~Heal yourself")
menu:AddItem(click)
menu.OnItemSelect = function(sender, item, index)
    if item == click then
        SetEntityHealth(PlayerPedId(), 200)
        notify("~g~Healed.")
    end
end
end


-- voor "ThirdItem"
weapons = {
"weapon_sniperrifle",
"weapon_pistol",
"weapon_rpg"
}
function ThirdItem(menu)
local gunsList = NativeUI.CreateListItem("Get Guns", weapons, 1)
menu:AddItem(gunsList)
menu.OnListSelect = function(sender, item, index)
    if item == gunsList then
        local selectedGun = item:IndexToItem(index)
        giveWeapon(selectedGun)
        notify("spawned in a "..selectedGun)
    end
end
end
-- voor "FourthItem"

seats = {-1,0,1,2}
function FourthItem(menu)

local submenu = _menuPool:AddSubMenu(menu, "~b~Sub Menu")
local carItem = NativeUI.CreateItem("Spawn car", "Spawn car in a submenu")
carItem.Activated = function(sender, item)
    if item == carItem then
        spawnCar("adder")
        notify("spawned in an adder")
    end
end
local seat = NativeUI.CreateSliderItem("Change seat", seats, 1)
submenu.OnSliderChange = function(sender, item, index)
    if item == seat then
        vehSeat = item:IndexToItem(index)
        local pedsCar = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        SetPedIntoVehicle(PlayerPedId(), pedsCar, vehSeat)
    end
end
submenu:AddItem(carItem)
submenu:AddItem(seat)
_menuPool:MouseControlsEnabled (false)
_menuPool:MouseEdgeEnabled (false)
_menuPool:ControlDisablingEnabled(false)
end

FirstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
FourthItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
while true do
    Citizen.Wait(0)
    _menuPool:ProcessMenus()
    --[[ de 'E' opend de menu ]]
    if IsControlJustPressed(1, 51) then
        mainMenu:Visible(not mainMenu:Visible())
    end
end
end)

function notify(text)
SetNotificationTextEntry("STRING")
AddTextComponentString(text)
DrawNotification(true, true)
end

function giveWeapon(hash)
GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function spawnCar(car)
local car = GetHashKey(car)

RequestModel(car)
while not HasModelLoaded(car) do
    RequestModel(car)
    Citizen.Wait(50)
end

local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

SetEntityAsNoLongerNeeded(vehicle)
SetModelAsNoLongerNeeded(vehicleName)

--[[ SetEntityAsMissionEntity(vehicle, true, true) ]]
end
