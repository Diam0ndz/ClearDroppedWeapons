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

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	
	HookEvent("round_poststart", Event_RoundPostStart);
}

public Action Event_RoundPostStart(Event event, const char[] name, bool dontBroadcast)
{
	int maxEntities = GetMaxEntities();
	char weapName[64];
	
	for (int i = 0; i < maxEntities; i++)
	{
		if(IsValidEdict(i))
		{
			GetEdictClassname(i, weapName, sizeof(weapName));
			if(strcmp(weapName, "weapon", false) == 0)
			{
				RemoveEdict(i);
			}
		}
	}
	return Plugin_Continue;
}