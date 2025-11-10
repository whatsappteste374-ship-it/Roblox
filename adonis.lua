-- by DarkForgeX - Open Source
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local d = rawget(v, "Detected")
        if typeof(d) == "function" then
            hookfunction(d, function(_, _, _)
                return true
            end)
        end

        local k = rawget(v, "Kill")
        if typeof(k) == "function" then
            hookfunction(k, function(_)
            end)
        end
    end
end
print("Adonis system activated")
