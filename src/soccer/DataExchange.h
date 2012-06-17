#ifndef SOCCER_DATAEXCHANGE_H
#define SOCCER_DATAEXCHANGE_H

#include <map>
#include <boost/shared_ptr.hpp>

#include <tinyxml.h>

#include "soccer/Continent.h"

namespace Soccer {

class Match;
class Player;
class Team;

class DataExchange {
	public:
		static boost::shared_ptr<Player> parsePlayer(const TiXmlElement* pelem);
		static boost::shared_ptr<Match> parseMatchDataFile(const char* fn);
		static void createMatchDataFile(const Match& m, const char* fn);

		static void updateTeamDatabase(const char* fn, TeamDatabase& db);
		static void updatePlayerDatabase(const char* fn, PlayerDatabase& db);
		static boost::shared_ptr<Team> parseTeam(const TiXmlElement* teamelem);
		static TiXmlElement* createTeamElement(const Team& t, bool reference_players);
		static TiXmlElement* createPlayerElement(const Player& p);

		static void createTeamDatabase(const char* fn, const TeamDatabase& db);
		static void createPlayerDatabase(const char* fn, const PlayerDatabase& db);
};


}


#endif

