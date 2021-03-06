#define STALEMATE_TIMER 100 MINUTES
#define BASE_ASSAULT_ONEFLANK_THRESHOLD 15
#define BASE_ASSAULT_TWOFLANK_THRESHOLD 30

/datum/game_mode/base_assault
	name = "Base Assault"
	config_tag = "base_assault"
	round_description = "Assault a well-defended UNSC base."
	extended_round_description = "Assault a well defended UNSC base and plant a bomb."
	probability = 1
	ship_lockdown_duration = 10
	faction_balance = list(/datum/faction/covenant,/datum/faction/unsc)
	var/stalemate_at = 0
	var/winning_side = "error"
	var/list/flank_tags = list("rightflank","leftflank")

/datum/game_mode/base_assault/pre_setup()
	. = ..()
	stalemate_at = world.time + STALEMATE_TIMER
	GLOB.COVENANT.has_flagship = 1
	GLOB.UNSC.has_base = 1

	var/flanks_close = 2
	if(GLOB.clients.len > BASE_ASSAULT_ONEFLANK_THRESHOLD)
		flanks_close = 1
	else if(GLOB.clients.len > BASE_ASSAULT_TWOFLANK_THRESHOLD)
		flanks_close = 0
	if(flanks_close > 0)
		for(var/i = 1 to flanks_close)
			var/tag_close = "landmark*[pick(flank_tags)]"
			var/obj/rockspawn_mark = locate(tag_close)
			while(rockspawn_mark)
				var/turf/rockspawn_loc = rockspawn_mark.loc
				if(rockspawn_loc)
					rockspawn_loc.ChangeTurf(/turf/unsimulated/mineral)
				qdel(rockspawn_mark)
				rockspawn_mark = locate(tag_close)

/datum/game_mode/base_assault/check_finished()
	if(world.time >= stalemate_at)
		winning_side = "Nobody. Stalemate!"
		return 1
	var/obj/effect/overmap/base = GLOB.UNSC.get_base()
	if(!base || isnull(base.loc) || base.superstructure_failing )
		winning_side = "The Covenant"
		return 1
	base = GLOB.COVENANT.get_flagship()
	if(!base || isnull(base.loc) || base.superstructure_failing)
		winning_side = "The UNSC"
		return 1
	return 0

/datum/game_mode/base_assault/declare_completion()
	. = ..()
	to_world("<span class = 'danger'>The winning faction was: [winning_side]</span>")

/datum/map/base_assault
	name = "UNSC Outpost"
	full_name = "111 Tauri System, UNSC Outpost"
	system_name = "111 Tauri"
	path = "base_assault"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/ks7_elmsville/hud_icons.dmi'
	station_networks = list("Exodus")
	station_name  = "UNSC Outpost"
	station_short = "UNSC Outpost"
	dock_name     = "Space Elevator"
	boss_name     = "United Nations Space Command"
	boss_short    = "UNSC HIGHCOM"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"

	use_overmap = 1
	overmap_size= 10
	overmap_event_tokens = 1

	allowed_gamemodes = list("base_assault")
	map_admin_faxes = list("Ministry of Tranquility (General)","Ministry of Resolution (War Matters)","Ministry of Fervent Intercession (Internal Affairs)")

#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/base_assault

	#include "unit_tests.dm"

	#include "../npc_ships/om_ship_areas.dm"
	#include "../area_holders/overmap_ship_area_holder.dmm"

	#include "../Admin Planet/includes.dm"

	#include "../faction_bases/CassiusMoonStation/cassiusmoon.dm"

	#include "../CRS_Unyielding_Transgression/includes.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#include "../../code/modules/halo/supply/unsc.dm"
	#include "../../code/modules/halo/supply/oni.dm"
	#include "../../code/modules/halo/supply/covenant.dm"

	#include "../faction_bases/complex046/complex046.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Base Assault
#endif

//Spawn In Overrides//
/obj/effect/overmap/complex046

/obj/effect/overmap/unsc_cassius_moon
	overmap_spawn_in_me = list(/obj/effect/overmap/complex046)

/datum/map/base_assault
	allowed_jobs = list(\
	/datum/job/unsc/spartan_two,
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/hellbringer,\
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
	/datum/job/covenant/huragok,
	/datum/job/covenant/sangheili_minor,
	/datum/job/covenant/sangheili_major,
	/datum/job/covenant/sangheili_ultra,
	/datum/job/covenant/sangheili_shipmaster,
	/datum/job/covenant/kigyarminor,
	/datum/job/covenant/unggoy_minor,
	/datum/job/covenant/unggoy_major,
	/datum/job/covenant/unggoy_ultra,
	/datum/job/covenant/unggoy_deacon,
	/datum/job/covenant/unggoy_heavy,
	/datum/job/covenant/skirmmurmillo,
	/datum/job/covenant/skirmcommando,
	/datum/job/covenant/skirmchampion,
	/datum/job/covenant/brute_minor,
	/datum/job/covenant/brute_major,
	/datum/job/covenant/brute_captain,
	/datum/job/covenant/yanmee_minor,
	/datum/job/covenant/yanmee_major,
	/datum/job/covenant/yanmee_ultra,
	/datum/job/covenant/yanmee_leader,
	)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,\
		"UNSC Base Spawns",\
		"UNSC Base Fallback Spawns"\
		)

	default_spawn = DEFAULT_SPAWNPOINT_ID