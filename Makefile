CXX      ?= g++
AR       ?= ar
CXXFLAGS ?= -std=c++11 -O2 -g3 -Werror -ftemplate-depth=512
CXXFLAGS += -Wall -Wshadow

CXXFLAGS += $(shell sdl-config --cflags)

FREEKICKLIBS = $(shell sdl-config --libs) -lSDL_image -lSDL_ttf -lGL -ltinyxml -lboost_serialization -lboost_iostreams
SWOS2FKLIBS = -ltinyxml -lboost_serialization


CXXFLAGS += -Isrc
BINDIR       = bin


# Common lib

COMMONSRCFILES = SDLSurface.cpp Texture.cpp SDL_utils.cpp Color.cpp Math.cpp Quaternion.cpp Steering.cpp Random.cpp
COMMONSRCDIR = src/common
COMMONSRCS = $(addprefix $(COMMONSRCDIR)/, $(COMMONSRCFILES))
COMMONOBJS = $(COMMONSRCS:.cpp=.o)
COMMONDEPS = $(COMMONSRCS:.cpp=.dep)
COMMONLIB = $(COMMONSRCDIR)/libcommon.a


# Libsoccer

LIBSOCCERSRCFILES = Player.cpp Team.cpp Match.cpp \
		    Competition.cpp League.cpp Cup.cpp Season.cpp Tournament.cpp \
		    ai/AITactics.cpp \
		    Continent.cpp DataExchange.cpp
LIBSOCCERSRCDIR = src/soccer
LIBSOCCERSRCS = $(addprefix $(LIBSOCCERSRCDIR)/, $(LIBSOCCERSRCFILES))
LIBSOCCEROBJS = $(LIBSOCCERSRCS:.cpp=.o)
LIBSOCCERDEPS = $(LIBSOCCERSRCS:.cpp=.dep)
LIBSOCCERLIB = $(LIBSOCCERSRCDIR)/libsoccer.a


# Soccer

SOCCERBINNAME = freekick3
SOCCERBIN     = $(BINDIR)/$(SOCCERBINNAME)
SOCCERSRCDIR  = src/soccer
SOCCERSRCFILES = gui/Widget.cpp gui/Button.cpp gui/Image.cpp gui/Slider.cpp \
		 gui/Screen.cpp gui/ScreenManager.cpp \
		 gui/MatchResultScreen.cpp gui/MainMenuScreen.cpp gui/TeamBrowser.cpp \
		 gui/FriendlyScreen.cpp gui/PresetLeagueScreen.cpp \
		 gui/PresetCupScreen.cpp gui/PresetSeasonScreen.cpp \
		 gui/PresetTournamentScreen.cpp \
		 gui/LoadGameScreen.cpp gui/UsageScreen.cpp \
		 gui/CompetitionScreen.cpp gui/LeagueScreen.cpp \
		 gui/CupScreen.cpp gui/SeasonScreen.cpp gui/TournamentScreen.cpp \
		 gui/TeamSelectionScreen.cpp \
		 gui/TeamTacticsScreen.cpp \
		 gui/Menu.cpp main.cpp
SOCCERSRCS = $(addprefix $(SOCCERSRCDIR)/, $(SOCCERSRCFILES))
SOCCEROBJS = $(SOCCERSRCS:.cpp=.o)
SOCCERDEPS = $(SOCCERSRCS:.cpp=.dep)


# Match

MATCHBINNAME = freekick3-match
MATCHBIN     = $(BINDIR)/$(MATCHBINNAME)
MATCHSRCDIR = src/match
MATCHSRCFILES = Clock.cpp Pitch.cpp Ball.cpp \
	   Match.cpp MatchHelpers.cpp MatchEntity.cpp Team.cpp Player.cpp PlayerActions.cpp \
	   Referee.cpp RefereeActions.cpp \
	   ai/AIActions.cpp ai/AIHelpers.cpp \
	   ai/AIGoalkeeperState.cpp ai/AIDefendState.cpp \
	   ai/AIMidfielderState.cpp ai/AIKickBallState.cpp ai/AIOffensiveState.cpp \
	   ai/PlayerAIController.cpp ai/AIPlayStates.cpp ai/AITacticParameters.cpp \
	   MatchSDLGUI.cpp \
	   main.cpp

MATCHSRCS = $(addprefix $(MATCHSRCDIR)/, $(MATCHSRCFILES))
MATCHOBJS = $(MATCHSRCS:.cpp=.o)
MATCHDEPS = $(MATCHSRCS:.cpp=.dep)


# swos2fk

SWOS2FKBINNAME = swos2fk
SWOS2FKBIN     = $(BINDIR)/$(SWOS2FKBINNAME)
SWOS2FKSRCDIR  = src/tools/swos2fk
SWOS2FKSRCFILES = main.cpp

SWOS2FKSRCS = $(addprefix $(SWOS2FKSRCDIR)/, $(SWOS2FKSRCFILES))
SWOS2FKOBJS = $(SWOS2FKSRCS:.cpp=.o)
SWOS2FKDEPS = $(SWOS2FKSRCS:.cpp=.dep)



.PHONY: clean all

all: $(SWOS2FKBIN) $(SOCCERBIN) $(MATCHBIN)

$(BINDIR):
	mkdir -p $(BINDIR)

$(COMMONLIB):
	git submodule update --init
	make -C $(COMMONSRCDIR)

$(LIBSOCCERLIB): $(LIBSOCCEROBJS)
	$(AR) rcs $(LIBSOCCERLIB) $(LIBSOCCEROBJS)

$(SWOS2FKBIN): $(BINDIR) $(SWOS2FKOBJS) $(COMMONLIB) $(LIBSOCCERLIB)
	$(CXX) $(SWOS2FKLIBS) $(LDFLAGS) $(SWOS2FKOBJS) $(LIBSOCCERLIB) $(COMMONLIB) -o $(SWOS2FKBIN)

$(SOCCERBIN): $(BINDIR) $(COMMONLIB) $(LIBSOCCERLIB) $(SOCCEROBJS)
	$(CXX) $(FREEKICKLIBS) $(LDFLAGS) $(SOCCEROBJS) $(LIBSOCCERLIB) $(COMMONLIB) -o $(SOCCERBIN)

$(MATCHBIN): $(BINDIR) $(COMMONLIB) $(LIBSOCCERLIB) $(MATCHOBJS)
	$(CXX) $(FREEKICKLIBS) $(LDFLAGS) $(MATCHOBJS) $(LIBSOCCERLIB) $(COMMONLIB) -o $(MATCHBIN)

%.dep: %.cpp
	@rm -f $@
	@$(CC) -MM $(CXXFLAGS) $< > $@.P
	@sed 's,\($(notdir $*)\)\.o[ :]*,$(dir $*)\1.o $@ : ,g' < $@.P > $@
	@rm -f $@.P

clean:
	find src/ -name '*.o' -exec rm -rf {} +
	find src/ -name '*.dep' -exec rm -rf {} +
	find src/ -name '*.a' -exec rm -rf {} +
	rm -rf $(MATCHBIN) $(SOCCERBIN) $(SWOS2FKBIN)
	rmdir $(BINDIR)

-include $(MATCHDEPS) $(SOCCERDEPS) $(LIBSOCCERDEPS) $(COMMONDEPS) $(SWOS2FKDEPS)

