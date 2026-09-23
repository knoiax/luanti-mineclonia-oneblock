local modname = minetest.get_current_modname()

mcl_eodp = {} -- Namespace global exclusivo para tu mod

-- Tabla centralizada de prefijos accesible desde cualquier lugar
mcl_eodp.prefix = {
    de_papi      = modname .. ":",
    italian_food = modname .. ":it_f_",
    morefood     = modname .. ":m_mf_",
    bronze_stuff = modname .. ":m_b_s_",
    copper_golem = modname .. ":c_g_",
}

-- Mapeo para créditos
mcl_eodp.credits = {
    eodp_it_f_  = { mod = "Italian Food", author = "Comunidad Luanti / Autores Originales" },
    eodp_m_mf_  = { mod = "MoreFood", author = "Comunidad Luanti / Autores Originales" },
    eodp_m_b_s_ = { mod = "Bronze Stuff", author = "MiracleNebulae" },
    eodp_c_g_   = { mod = "Copper Golem", author = "nando y NO11" },
}