local options={
    {
       key="dd_options",
       name="Damage Deal - Options",
       desc="Damage Deal - Options",
       type="section",
    },
	{
		key     = "mo_zombiehp",
		name    = "Zombie HP",
		desc    = "Zombie's health",
		type    = "number",
		section = "dd_options",
		def     = 50000,
		min     = 2000,
		max     = 9999999999,
	},
}

return options
