## Copyright (C) 2025 BOICHOT
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} to_grayscale (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: BOICHOT <BOICHOT@DESKTOP-3CCLSPD>
## Created: 2025-07-01

% --- Helper function: convert 2-bit to grayscale ---
function img = to_grayscale(frame)
    img = uint8(...
        (frame == 3) * 255 + ...
        (frame == 2) * 125 + ...
        (frame == 1) * 80  + ...
        (frame == 0) * 0);
end
