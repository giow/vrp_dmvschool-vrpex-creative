--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
htmlEntities = module("vrp", "lib/htmlEntities")

vRPdmv = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
DMVclient = Tunnel.getInterface("vrp_dmvschool")
Tunnel.bindInterface("vrp_dmvschool",vRPdmv)
Proxy.addInterface("vrp_dmvschool",vRPdmv)
cfg = module("vrp_dmvschool", "cfg/dmv")

function vRPdmv.setLicense()
	local user_id = vRP.getUserId(source)
	vRP.setUData(user_id,"vRP:dmv:license",json.encode(os.date("%x")))
end

function vRPdmv.payTheory()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryPayment(user_id,250) then
        DMVclient.startTheory(player)
	else
		TriggerClientEvent("pNotify:SendNotification", player, {
      text = "Dinheiro Insuficiente",
      type = "error",progressBar = false,timeout = 3000,layout = "nycolaaz",queue = "left",
      animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}
    })
	end
end

function vRPdmv.payPractical()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryPayment(user_id,500) then
        DMVclient.startPractical(player)
	else
		TriggerClientEvent("pNotify:SendNotification", player, {
      text = "Dinheiro Insuficiente",
      type = "error",progressBar = false,timeout = 3000,layout = "nycolaaz",queue = "left",
      animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}
    })
	end
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local data = vRP.getUData(user_id,"vRP:dmv:license")
	if data then
	  local license = json.decode(data)
	  if license and license ~= 0 then
        DMVclient.setLicense(player, true)
	  end
	end
end)

RegisterCommand("vercnh",function(source,args)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
      local nuser_id = args[1]  
      local data = vRP.getUData(nuser_id,"vRP:dmv:license")
      local license = json.decode(data)

      if nuser_id == nil then
        nuser_id = 0
      end  

      print(license)

      if license == nil then
        TriggerClientEvent("Notify",source,"negado","Passaporte "..parseInt(args[1]).." não possui CNH")
      end 
      
      if license ~= nil and license ~= "" and license ~= 0 and license ~= "null" then
        TriggerClientEvent("Notify",source,"sucesso","Passaporte "..parseInt(args[1]).." possui CNH")
      end
    else
      TriggerClientEvent("Notify",source,"negado","Você não é um polícial")
    end  
end)

RegisterCommand("retirarcnh",function(source,args)
  local user_id = vRP.getUserId(source)

  if vRP.hasPermission(user_id,"policia.permissao") then
    local nuser_id = args[1]  

    vRP.setUData(nuser_id,"vRP:dmv:license",json.encode())

    TriggerClientEvent("Notify",source,"sucesso","CNH removida do passaporte: "..parseInt(args[1]).."")
  else    
    TriggerClientEvent("Notify",source,"negado","Você não é um polícial")
  end  
end)

RegisterCommand("cnh",function(source,args)
  local user_id = vRP.getUserId(source)
    local user_id = vRP.getUserId(source)
    local data = vRP.getUData(user_id,"vRP:dmv:license")
    local license = json.decode(data)

    if user_id == nil then
      user_id = 0
    end  

    print(license)

    if license == nil then
      TriggerClientEvent("Notify",source,"negado","Você não possui CNH")
    end 
    
    if license ~= nil and license ~= "" and license ~= 0 and license ~= "null" then
      TriggerClientEvent("Notify",source,"sucesso","Você possui CNH")
    end  
end)