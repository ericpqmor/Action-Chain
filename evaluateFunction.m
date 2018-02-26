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
  
  %Defining weight functions
  BALL_X_CORD_WEIGHT = 1;
  BALL_OPPONENT_GOAL_DISTANCE_WEIGHT = 1;
  KICKABLE_FROM_POS_WEIGHT = 1;
  HOLDER_SELF_WEIGHT = 1;
  OPPONENTS_DISTANCE_WEIGHT = 1;
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
  
  if (920<=x && x<=940 && 250<=y && y<=350)
    #disp("Inside enemy goal")
    evaluateState = 2000;
  elseif (0<=x && x<=20 && 250<=y && y<=350)
    #disp("Inside ally goal")
    evaluateState = -2000;
  elseif (x<=20 || x>=920 || y<=0 || y>=900)
    #disp("Out of bounds")
    evaluateState = -1000;
  else
    #disp("Basic evaluation")
    evaluateState = BALL_X_CORD_WEIGHT * x;
  end
  
endfunction
