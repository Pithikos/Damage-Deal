unitDef = {
  unitname            = "zombie_land",
  name                = "Zombie",
  description         = "Zombie at land",
  category            = "ALL NOTLAND NOTAIR NOTSHIP NOWEAPON",
  corpse              = "ZOMBIE_LAND_DEAD",
  defaultmissiontype  = "Standby",
  explodeAs           = "NUCLEAR_MISSILE",
  floater             = false,
  footprintX          = 8,
  footprintZ          = 8,
  iconType            = "zombie",
  idleAutoHeal        = 40;
  idleTime            = 0;
  leaveTracks         = false,
  mass                = 15000,
  maxDamage           = 60000,
  maxSlope            = 18,
  seismicSignature    = 0,
  turninplace         = 0,
  noChaseCategory     = "VTOL",
  objectName          = "ZOMBIE_LAND",
  selfDestructAs      = "NUCLEAR_MISSILE",
  collisionVolumeType = "box",
  collisionVolumeOffsets = "0 -3 -3",
  collisionVolumeScales = "18 26 40",
  
  side                = "ZOMBIE",
  sightDistance       = 1024,
  TEDClass            = "BUILDING",
  trackWidth          = 18,
  waterline           = 8,
  workerTime          = 0,

  featureDefs         = {

    DEAD = {
				world="All Worlds";
				description="Zombie Wreckage";
				category="corpses";
				object="ZOMBIE_LAND_DEAD";
				featuredead="ZOMBIE_LAND_DEAD";
				footprintx=8;
				footprintz=8;
				height=40;
				blocking=1;
				hitdensity=100;
				metal=17850;
				damage=10440;
				reclaimable=1;
				featurereclamate="SMUDGE01";
				seqnamereclamate="TREE1RECLAMATE";
				energy=0;
    },


    HEAP = {
				world="All Worlds";
				description="Zombie Wreckage";
				category="corpses";
				object="ZOMBIE_LAND_DEAD";
				featuredead="ZOMBIE_LAND_DEAD";
				footprintx=8;
				footprintz=8;
				height=15;
				blocking=1;
				hitdensity=100;
				metal=17850;
				damage=10440;
				reclaimable=1;
				featurereclamate="SMUDGE01";
				seqnamereclamate="TREE1RECLAMATE";
				energy=0;
    },

  },

}

return lowerkeys({ zombie_land = unitDef })
