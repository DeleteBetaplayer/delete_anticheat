
logGonderDiscord = "https://discord.com/api/webhooks/1323389115408060426/gsqbKlSLI-_1Bhq3aNKVZAGxlqM8fvPyNNbuQPffQZrZgGjaJHmKWANMZV9plLhXCz4E"
keyKontrol55a98f41="pasif"
ImageURL = "https://media.discordapp.net/attachments/1323006573664014436/1325560168640938175/deleteacpp.png?ex=677c3b9b&is=677aea1b&hm=5a673e3c01da6c44fcb524b79c622de04b6a75123bac451eb286982e9af364d0&=&format=webp&quality=lossless&width=671&height=671"
LargeImageURL = "https://media.discordapp.net/attachments/1323006573664014436/1325559528367849614/DELETE_AC.png?ex=677c3b03&is=677ae983&hm=3be34a18682ee6807dda8c120e404e3cb82b75f125e5b0b145ea9b67d7fb3c43&=&format=webp&quality=lossless"
Large2ImageURL = "https://media.discordapp.net/attachments/1323006573664014436/1325559528674295838/delete_lisans.png?ex=677c3b03&is=677ae983&hm=0d351c8be27b00878fc206608cc82971b32893208f9325960081e0ff4eaf8d25&=&format=webp&quality=lossless"
lisansliScriptAdi = ""
kontrol = nil
kontrol2 = nil
sunucuIP = "Bulunamadı"
local webhookURL = "https://discord.com/api/webhooks/1323389115408060426/gsqbKlSLI-_1Bhq3aNKVZAGxlqM8fvPyNNbuQPffQZrZgGjaJHmKWANMZV9plLhXCz4E" -- Discord Webhook URL

function getServerIp()
    return getServerConfigSetting ("serverip")
end

function getRealServerIP(callback)
    fetchRemote(
        "http://ipinfo.io/ip",
        function(responseData, errno)
            if errno == 0 then
                -- IP adresini başarıyla aldık
                callback(responseData:match("%S+")) -- Boşlukları temizle
            else
                -- Hata durumunda
                callback(nil)
            end
        end
    )
end

-- Örnek kullanım
getRealServerIP(function(ip)
    if ip then
        sunucuIP = ip
    else
        sunucuIP = "auto"
    end
end)

function DeleteLicenseContent(licenseOwner,scriptName4)
    if licenseOwner == "Lisans Bulunamadı" then
        colors = 0x00FF0000
    else
        colors = 0x0033CCFF
    end
    local licenseOwner = licenseOwner or "Lisans aktif edilemedi"
    local sendOptions = {
        content = "",
        embeds = {
            {
                title = "Delete Lisans Bilgi Sistemi",
                color = colors,
                fields = {
                    {name="Sunucu IP Adresi:", value="```"..sunucuIP.."```", inline=false},
                    {name="Sunucu Adı:", value="```"..getServerName( ).."```", inline=false},
                    {name="Lisans Sahibi:", value="```"..licenseOwner.."```", inline=false},
                    {name="Script Adı:", value="```"..scriptName4.."```", inline=false},
                },
                thumbnail = {
                    url = ImageURL 
                },
                image = {
                    url = Large2ImageURL 
                }
            },
        },
    }

    local jsonData = toJSON(sendOptions):sub(2, -2)
    fetchRemote(webhookURL, {
        queueName = "Delete Medya",
        connectionAttempts = 3,
        connectTimeout = 10000,
        method = "POST",
        headers = {
            ["Content-Type"] = "multipart/form-data",
        },
        formFields = {
            payload_json = jsonData,
        },
    }, function(responseData, response)
        if not response.success then
            print("Response Error:", response.statusCode, responseData)
        end
    end)
end


function DeleteAcContent(player,durumu)
    local licenseOwner = licenseOwner or "Lisans aktif edilemedi"
    local sendOptions = {
        content = "",
        embeds = {
            {
                title = "Delete Anticheat Bilgi Sistemi",
                color = 0x009966CC,
                fields = {
                    {name="Atılan Oyuncu:", value="```"..getPlayerName(player).."```", inline=false},
                    {name="Atılma Sebebi:", value="```"..durumu.."```", inline=false},
                    {name="Atılan Oyuncunun Seriali:", value="```"..getPlayerSerial(player).."```", inline=false},
                    {name="Atılan Oyuncunun IP'si:", value="```"..getPlayerIP(player).."```", inline=false},
                },
                thumbnail = {
                    url = ImageURL 
                },
                image = {
                    url = LargeImageURL 
                }
            },
        },
    }

    local jsonData = toJSON(sendOptions):sub(2, -2)
    fetchRemote(discordWebhookURL, {
        queueName = "Delete Medya",
        connectionAttempts = 3,
        connectTimeout = 10000,
        method = "POST",
        headers = {
            ["Content-Type"] = "multipart/form-data",
        },
        formFields = {
            payload_json = jsonData,
        },
    }, function(responseData, response)
        if not response.success then
            print("Response Error:", response.statusCode, responseData)
        end
    end)
end



--sendDiscordMessage("[DLT-Anticheat] Anticheat aktif edildi.") 

function keyiDogrula485(licenseKey,scriptadi)
    local lisansURLKeyDecps = "https://delete-anticheat-default-rtdb.firebaseio.com/licenses/" .. licenseKey .. ".json"

    fetchRemote(lisansURLKeyDecps, function(response, errno)
        if errno == 0 then
            local result = fromJSON(response)
            if result and result.valid then
                outputChatBox("[Lisans]: Lisans doğrulandı. Sahibi: " .. (result.owner or "Bilinmiyor"), root, 0, 255, 0)
              keyKontrol55a98f41="aktif"
              DeleteLicenseContent(result.owner,scriptadi)
                else
              --  outputChatBox("[Lisans Hatası]: Geçersiz lisans!", root, 255, 0, 0)
                cancelEvent()
                keyKontrol55a98f41="pasif"
                DeleteLicenseContent("Lisans Bulunamadı",scriptadi)
            end
        else
          --  outputChatBox("[Lisans Hatası]: Firebase bağlantısı başarısız! Hata kodu: " .. errno, root, 255, 0, 0)
        end
    end)
end



addEventHandler("onResourceStart", resourceRoot, function(res)
    local serverLicenseKey = lisansKey -- Sunucunun lisans anahtarı
    lisansliScriptAdi = getResourceName(res)
    keyiDogrula485(serverLicenseKey,lisansliScriptAdi)
end)



addEventHandler("onElementDataChange", root, function(dataName, oldValue, newValue)
    if keyKontrol55a98f41 == "pasif" then 
        lisansHataGonder()
    return end

    if yasakliDatalar[dataName] then
        local izinliScriptler = yasakliDatalar[dataName]
        local degistirenScript = getResourceName(sourceResource) 

        if not table.contains(izinliScriptler, degistirenScript) then
            DeleteAcContent(source,"Yetkisiz data")
            kickPlayer(source, "Yetkisiz data değişikliği başarılı!")
        end
    end
end)

function table.contains(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end




local explosionLimit = 5
local explosionTimeout = 5
local playerExplosions = {}

addEventHandler("onPlayerWeaponFire", root, 
    function(weapon, _, _, _, _, _, _, _, hitElement)
        if keyKontrol55a98f41 == "pasif" then 
            lisansHataGonder()
        return end
        if weapon == 16 or weapon == 17 or weapon == 18 or weapon == 35 or weapon == 36 then -- RPG, Bombalar vb.
            local player = source
            local now = getTickCount()

            if not playerExplosions[player] then
                playerExplosions[player] = {}
            end

            table.insert(playerExplosions[player], now)

            -- Zaman aşımına uğrayan patlamaları temizle
            for i = #playerExplosions[player], 1, -1 do
                if now - playerExplosions[player][i] > explosionTimeout * 1000 then
                    table.remove(playerExplosions[player], i)
                end
            end

            if #playerExplosions[player] > explosionLimit then
                -- Oyuncu fazla patlama oluşturuyorsa, cezalandır
                DeleteAcContent(player,"Patlama Hilesi")
                kickPlayer(player, "Çok fazla patlama oluşturduğunuz için atıldınız.")
            end
        end
    end
)

local maxHeight = 10 -- Maksimum izin verilen zıplama yüksekliği

addEventHandler("onPlayerWasted", root, 
    function()
        if keyKontrol55a98f41 == "pasif" then 
            lisansHataGonder()
       return end
        local x, y, z = getElementPosition(source)
        if z > maxHeight then
            if getElementData(source,"loggedin") == 1 then
                DeleteAcContent(source,"Hız Hilesi")
            kickPlayer(source, "Uçma hilesi tespit edildi.")
            end
        end
    end
)


function monitorVehicleSpeed()
    if keyKontrol55a98f41 == "pasif" then 
        lisansHataGonder()
    return end
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player,"loggedin") == 1 then
        local vehicle = getPedOccupiedVehicle(player)
        if vehicle then
            local vx, vy, vz = getElementVelocity(vehicle)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2) * 180 -- Hızı km/h'ye çeviriyoruz

            if speed > maxSpeed then
                DeleteAcContent(player,"Hız Hilesi")
                kickPlayer(player, "Hız hilesi tespit edildi.")
                
            end
        end
    end
    end
end
setTimer(monitorVehicleSpeed, 1000, 0) 
local playerPositions = {}

setTimer(function()
    if keyKontrol55a98f41 == "pasif" then 
        lisansHataGonder()
    return end
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player,"loggedin") == 1 then

        if not isPedDead(player) then
            local x, y, z = getElementPosition(player)
            local id = getElementData(player, "id") or getPlayerName(player)

            if playerPositions[id] then
                local oldX, oldY, oldZ = unpack(playerPositions[id])
                local distance = getDistanceBetweenPoints3D(oldX, oldY, oldZ, x, y, z)

                if distance > 50 then -- 50 birim/sn limit
                    DeleteAcContent(player,"Hız Hilesi")
                    kickPlayer(player, "Hız hilesi kullandığınız tespit edildi.")
                end
            end

            playerPositions[id] = {x, y, z}
        end
    end
    end
end, 1000, 0)


addEventHandler("onPlayerResourceStart", root, function(resource)
    if keyKontrol55a98f41 == "pasif" then 
        lisansHataGonder()
    return end

        local resourceName = getResourceName(resource)
        if resourceName == "cheatpanel" or resourceName == "trainer" then
            DeleteAcContent(source,"Hile kaynağı çalıştırmaya çalıştığınız için atıldınız.")
            cancelEvent() 
            kickPlayer(source, "Hile kaynağı çalıştırmaya çalıştığınız için atıldınız.")
        end
end)

addEventHandler("onPlayerModInfo", root, function(modList)
    if keyKontrol55a98f41 == "pasif" then 
        lisansHataGonder()
    return end
    if #modList > 0 then
        local playerName = getPlayerName(source)
        DeleteAcContent(source,"Hile paneli tespit edildi")
        kickPlayer(source, "Hile paneli tespit edildi.")
    end
end)


function lisansHataGonder()
    if gonderildiMi488 then
    else
    DeleteLicenseContent("Lisans Bulunamadı",lisansliScriptAdi)
    gonderildiMi488 = true
    end
end



-- Hile tespiti ve admin paneline erişim kontrolü
addEventHandler("onPlayerLogin", root,
    function()
        -- Kullanıcıya ait hile kontrolü
        local player = source
        local playerName = getPlayerName(player)

        -- Hileli olabilecek bazı unsurlar: (örneğin, anormal ping veya hileli modlar)
        if isPlayerCheating(player) then
            DeleteAcContent(source,"Tehlike algılandı.")
            kickPlayer(player, "Hile kullanıyorsunuz, bu nedenle sunucudan atıldınız.")
            return
        end

    end
)

-- Hile kontrol fonksiyonu (basit bir örnek)
function isPlayerCheating(player)
    -- Burada, hile tespiti için daha gelişmiş yöntemler kullanılabilir.
    -- Örnek olarak anormal ping durumu veya yasaklı modların kullanılması gibi durumlar kontrol edilebilir.

    local ping = getPlayerPing(player)
    if ping > 500 then  -- Örnek: Yüksek pingli oyuncular şüpheli kabul edilir
        return true
    end

    -- Burada başka hile tespit yöntemleri eklenebilir
    -- Örneğin, yasaklı araç kullanımı veya anormal hızda hareket etme gibi

    return false
end



-- Komut engelleme fonksiyonu
function blockCommands(command)
    -- Oyuncunun serial numarasını alıyoruz
    local playerSerial = getPlayerSerial(source)

    -- Eğer oyuncunun serial numarası izin verilen listede değilse
    if not table.contains(serialList, playerSerial) then
        for _, blockedCommand in ipairs(KOMUT_ENGELLEME) do
            if command == blockedCommand then
                outputChatBox("[Delete-AC] Bu komutu kullanmaya yetkiniz yok!", source, 255, 0, 0)
                DeleteAcContent(source, "İzinsiz Komut Tespit Edildi! Komut: "..command.."")
                kickPlayer(source, "Admin veya üstü yetkiniz yok!")  
                cancelEvent()  -- Komutun çalışmasını engelle
                return
            end
        end
    end
end

-- Komut engelleme fonksiyonunu tetikleyen event
addEventHandler("onPlayerCommand", root, blockCommands)




-- `P` tuşuna basıldığında admin paneline erişimi kontrol etme
addEvent("checkAdminPanelAccess", true)
addEventHandler("checkAdminPanelAccess", root, function(player)
    local playerSerial = getPlayerSerial(player)

    -- Eğer oyuncunun serial numarası izin verilen listede değilse
    if not table.contains(serialList, playerSerial) then
        -- Admin paneline erişim engellenir, ancak `P` tuşuna basma işlemi engellenmez
        outputChatBox("[Delete-AC] Admin paneline erişim izniniz yok!", source, 255, 0, 0)
        cancelEvent()  -- Admin paneli açılmasın, ancak `P` tuşuna basmaya engel olma
    end
end)



-- Table içinde olup olmadığını kontrol etmek için fonksiyon
function table.contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end


local aimData = {}

-- Oyuncunun rakibini gerçekten görüp görmediğini kontrol eder
function checkLineOfSight(attacker, target)
    local x1, y1, z1 = getPedBonePosition(attacker, 8)
    local x2, y2, z2 = getPedBonePosition(target, 3)

    return isLineOfSightClear(x1, y1, z1, x2, y2, z2, true, false, false, true, false, false, false)
end

-- Hasar olayını kontrol et ve wallhack tespiti yap
addEventHandler("onPlayerDamage", root, function(attacker)
    if attacker and getElementType(attacker) == "player" then
        if not checkLineOfSight(attacker, source) then
            cancelEvent()
            DeleteAcContent(source, "Wallhack şüphesiyle engellendi")
            kickPlayer(attacker, "Wallhack şüphesi nedeniyle atıldınız.")
        end
    end
end)

-- Ateş olayında aimbot tespiti yap
addEventHandler("onPlayerWeaponFire", root, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    local attacker = source

    if hitElement and getElementType(hitElement) == "player" then
        local ax, ay, az = getPedTargetStart(attacker)
        local bx, by, bz = getPedTargetEnd(attacker)

        local aimAngle = math.deg(math.acos(((bx - ax) * (hitX - ax) + (by - ay) * (hitY - ay) + (bz - az) * (hitZ - az)) / 
                (getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) * getDistanceBetweenPoints3D(ax, ay, az, hitX, hitY, hitZ))))

        if not aimData[attacker] then aimData[attacker] = {shots = 0, suspicious = 0} end

        aimData[attacker].shots = aimData[attacker].shots + 1

        if aimAngle < 1 then
            aimData[attacker].suspicious = aimData[attacker].suspicious + 1
        end

        if aimData[attacker].shots >= 50 then
            local suspiciousRatio = aimData[attacker].suspicious / aimData[attacker].shots

            if suspiciousRatio > 0.7 then
                DeleteAcContent(source, " Aimbot şüphesiyle engellendi!")
                kickPlayer(attacker, "Aimbot şüphesi nedeniyle atıldınız.")
            end

            aimData[attacker] = nil
        end
    end
end)

-- Oyuncu çıktığında veya kicklendiğinde verileri temizle
addEventHandler("onPlayerQuit", root, function()
    aimData[source] = nil
end)
