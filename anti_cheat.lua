-- ====================================================================
-- SISTEMA DE BLOQUEO DE COMANDOS DE TRAMPA (ANTI-CHEAT ONEBLOCK)
-- ====================================================================

local blocked_commands = {
    "grant",
    "grantme",
    "give",
    "giveme",
    "revoke",
    "revokeme"
}

for _, cmd_name in ipairs(blocked_commands) do
    if minetest.registered_chatcommands[cmd_name] then
        minetest.register_chatcommand(cmd_name, {
            description = "Comando deshabilitado por el diseño de supervivencia OneBlock.",
            privs = { impossible_priv_to_prevent_bypass = true }, -- Privilegio falso que nadie posee
            func = function(name, param)
                -- Opcional: Registrar intento de trampa en los logs del servidor
                minetest.log("warning", "[Anti-Cheat] El jugador " .. tostring(name) .. " intentó usar el comando prohibido: /" .. cmd_name)
                
                -- Retornar mensaje de rechazo visible en el chat
                return false, "❌ [OneBlock De Papi] Este comando está estrictamente deshabilitado para preservar la experiencia de supervivencia."
            end,
        })
    end
end