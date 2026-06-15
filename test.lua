local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Target path setup
local targetRemote = nil
pcall(function()
    targetRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("URE/UpdateCamera")
end)

if targetRemote then
    print("[+] Found target object. Applying universal table/metatable hook...")
    
    -- Agar ye ek custom object (table) hai jo Sleitnick Net use karta hai
    local mt = getmetatable(targetRemote) or targetRemote
    
    -- Hum check karenge ki isme kaunse functions hain aur unhe intercept karenge
    local originalFunction = nil
    
    -- Sleitnick Net standard objects usually have a custom fire method or wrapped events
    -- Hum is pure object ke index function ko wrap kar dete hain
    if typeof(targetRemote) == "table" then
        print("[+] Object is a custom Net Table. Hooking methods...")
        for key, value in pairs(targetRemote) do
            if typeof(value) == "function" then
                local original = value
                targetRemote[key] = function(self, ...)
                    -- Code tracking logic
                    local src = debug.info(2, "s") or "Unknown"
                    print("--------------------------------------------------")
                    print("[!] Intercepted Net Method Call: " .. tostring(key))
                    print("[+] Calling Script/Location: " .. src)
                    print("--------------------------------------------------")
                    
                    -- Block spam completely
                    return nil
                end
            end
        end
    else
        -- Agar ye ek real Instance (Folder/Value/Remote) hai jiska metatable badla gaya hai
        print("[+] Object is a game Instance. Hooking index access...")
        
        -- Safe backup method: Object ko game se disable karne ka trial
        -- Agar ye spam kar raha hai, simple tareeka hai iska name badal do ya parent badal do 
        -- taaki script isko dundh na paye aur chalna band ho jaye!
        pcall(function()
            targetRemote.Name = "Blocked_UpdateCamera_" .. math.random(100,999)
            print("[+] Successfully renamed the remote to break the spammer's loop!")
        end)
    end
    
else
    warn("[-] Target object 'URE/UpdateCamera' nahi mila.")
end
