#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Diam0ndz"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Clear Dropped Weapons",
	author = PLUGIN_AUTHOR,
	description = "Deletes any weapons that are on the floor during round start",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/diam0ndz"
};

int weaponParent;

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	
	weaponParent = FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");

	HookEvent("round_poststart", Event_RoundPostStart);
}

public Action Event_RoundPostStart(Event event, const char[] name, bool dontBroadcast)
{
	CreateTimer(1.0, ClearGround);
}

public Action ClearGround(Handle timer)
{
	int maxEntities = GetMaxEntities();
	char weapon[64];
	
	for (int i = 0; i < maxEntities; i++)
	{
		if(IsValidEdict(i))
		{
			GetEdictClassname(i, weapon, sizeof(weapon));
			if((StrContains(weapon, "weapon_", false) != -1 || StrContains(weapon, "item_", false) != -1) && GetEntDataEnt2(i, weaponParent) == -1)
			{
				AcceptEntityInput(i, "Kill");
			}
		}
	}
	return Plugin_Continue;
}