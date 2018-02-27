## Copyright (C) 2018 ericpqmor
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} evaluateFunction (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: ericpqmor <ericpqmor@ericpqmor-computer-mint>
## Created: 2018-02-26

function evaluateState = evaluateFunction (x, y)
  
  x = x - 47;
  y = y - 30;
  
  %Defining weight functions
  BALL_X_CORD_WEIGHT = 1.61;
  BALL_OPPONENT_GOAL_DISTANCE_WEIGHT = 0.88;
  KICKABLE_FROM_POS_WEIGHT = 0.24;
  HOLDER_SELF_WEIGHT = 0.10;
  OPPONENTS_DISTANCE_WEIGHT = 8.59;
  PLAYERS_PER_SIDE = 6;
  
  %Reading the enemy data from enemies.txt
  enemies = load('enemies.txt');
  
  %Reading the allies data from allies.txt
  allies = load('allies.txt');
  
  distanceToBall = 9999999;
  holder = -1;
  
  for i=1:PLAYERS_PER_SIDE
    dx = allies(i,:)(1) - x;
    dy = allies(i,:)(2) - y;
    playerDistanceToBall = sqrt(dx*dx + dy*dy);
    if (playerDistanceToBall <= distanceToBall)
      distanceToBall = playerDistanceToBall;
      holder = i;
    end
  end
  
  if (45<=x && x<=47 && -5<=y && y<=5)
    # Inside enemy goal
    evaluateState = 100;
  elseif (-47<=x && x<=-45 && -5<=y && y<=5)
    # Inside ally goal
    evaluateState = -100;
  elseif (x<=-45 || x>=45 || y<=-30 || y>=30)
    # Out of bounds
    evaluateState = -50;
  else
    # Basic evaluation
    evaluateState = BALL_X_CORD_WEIGHT * x;
    
    # Distance to opp goal
    dx = abs(47-x);
    dy = abs(0-y);
    distOppGoal = sqrt(dx*dx + dy*dy);
    evaluateState += BALL_OPPONENT_GOAL_DISTANCE_WEIGHT * max(0,30-distOppGoal);
    
    # Bonus for free kicking/chipping situations
    someoneCanKick = false;
    for i = 1:PLAYERS_PER_SIDE
      if( visibility(i, enemies, allies) )
        someoneCanKick = true;
      end
    end
    
    if (someoneCanKick)
      evaluateState += KICKABLE_FROM_POS_WEIGHT * 100;
     
      if(visibility(holder, enemies, allies))
        evaluateState += HOLDER_SELF_WEIGHT * 50;
      end
    end
    
    # Considers closest opponent to ball distance
    oppMinDistanceToBall = 99999;
    for i=1:PLAYERS_PER_SIDE
      dx = enemies(i,:)(1) - x;
      dy = enemies(i,:)(2) - y;
      oppDistanceToBall = sqrt(dx*dx + dy*dy);
      if (oppDistanceToBall <= oppMinDistanceToBall)
        oppMinDistanceToBall = oppDistanceToBall;
      end
    end
    
    evaluateState -= OPPONENTS_DISTANCE_WEIGHT * max(0, 5-oppMinDistanceToBall);
    
  end
  
  x = x + 47;
  y = y + 30;
  
endfunction
