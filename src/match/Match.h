#ifndef MATCH_H
#define MATCH_H

#include <iostream>
#include <vector>
#include <map>

#include "match/Clock.h"
#include "match/Pitch.h"
#include "match/Team.h"
#include "match/Player.h"
#include "match/Ball.h"
#include "match/Referee.h"

enum class MatchHalf {
	NotStarted,
	FirstHalf,
	HalfTimePauseBegin,
	HalfTimePauseEnd,
	SecondHalf,
	Finished
};

std::ostream& operator<<(std::ostream& out, const MatchHalf& m);
bool playing(MatchHalf h);

enum class PlayState {
	InPlay,
	OutKickoff,
	OutThrowin,
	OutGoalkick,
	OutCornerkick,
	OutIndirectFreekick,
	OutDirectFreekick,
	OutPenaltykick,
	OutDroppedball
};

std::ostream& operator<<(std::ostream& out, const PlayState& m);
bool playing(PlayState h);

class Match {
	public:
		Match();
		const Team* getTeam(unsigned int team) const;
		const Player* getPlayer(unsigned int team, unsigned int idx) const;
		Player* getPlayer(unsigned int team, unsigned int idx);
		const Ball* getBall() const;
		Ball* getBall();
		const Referee* getReferee() const;
		void update(double time);
		bool matchOver() const;
		MatchHalf getMatchHalf() const;
		void setMatchHalf(MatchHalf h);
		void setPlayState(PlayState h);
		PlayState getPlayState() const;
		AbsVector3 convertRelativeToAbsoluteVector(const RelVector3& v) const;
		RelVector3 convertAbsoluteToRelativeVector(const AbsVector3& v) const;
		float getPitchWidth() const;
		float getPitchHeight() const;
		bool kickBall(Player* p, const AbsVector3& v);
		double getRollInertiaFactor() const;
		void addGoal(bool forFirst);
		int getScore(bool first) const;
		bool grabBall(Player* p);
		double getTime() const;
	private:
		void applyPlayerAction(const std::shared_ptr<PlayerAction> a,
				const std::shared_ptr<Player> p, double time);
		void updateReferee(double time);
		void updateTime(double time);
		std::shared_ptr<Team> mTeams[2];
		std::shared_ptr<Ball> mBall;
		std::map<std::shared_ptr<Player>, std::shared_ptr<PlayerAction>> mCachedActions;
		Referee mReferee;
		double mTime;
		double mTimeAccelerationConstant;
		MatchHalf mMatchHalf;
		PlayState mPlayState;
		Pitch mPitch;
		int mScore[2];
};

#endif
