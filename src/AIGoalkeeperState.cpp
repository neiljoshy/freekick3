#include "AIPlayStates.h"
#include "PlayerActions.h"

AIGoalkeeperState::AIGoalkeeperState(Player* p, PlayerAIController* m)
	: AIState(p, m)
{
}

std::shared_ptr<PlayerAction> AIGoalkeeperState::act(double time)
{
	/* TODO */
	return std::shared_ptr<PlayerAction>(new IdlePA());
}

