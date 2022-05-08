% Changed by Xuxiang to support higher MATLAB version
% 2022.05.08
%
% Copyright 2015 Communications Engineering Lab, KIT
%
% This is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3, or (at your option)
% any later version.
%
% This software is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this software; see the file COPYING. If not, write to
% the Free Software Foundation, Inc., 51 Franklin Street,
% Boston, MA 02110-1301, USA.

function make(varargin)
% make script for Simulink-HackRF
%   use "make -v" to get a verbose output

BIN_DIR = fullfile(pwd, 'build');
VERSION = '1.0.0';

%% Configuration
if ispc
    % this should point to the directory of hackrf.h
    HACKRF_INC_DIR = fullfile(pwd, 'deps', 'include', 'libhackrf');
    % this should point to the directory of libhackrf.a
    HACKRF_LIB_DIR = fullfile(pwd, 'deps', 'bin');
        
    options = { ...
        ['-I' pwd]; ['-I' HACKRF_INC_DIR]; ...
        ['-L' HACKRF_LIB_DIR]; '-llibhackrf' ...
    };

elseif isunix
    % this should point to the directory of hackrf.h
    HACKRF_INC_DIR = '/usr/include/libhackrf';
    
    options = { ...
        ['-I' HACKRF_INC_DIR]; ['-l' 'libhackrf'] ...
    };

else
    error('Platform not supported');
end

%% Prep
if (~exist(BIN_DIR, 'dir')); mkdir(BIN_DIR); end

% create bin order if not exist
options = [options; varargin'; { ...
    '-largeArrayDims'; ...
    ['-DSIMULINK_HACKRF_VERSION=' VERSION]; ...
    '-outdir'; BIN_DIR; ...
}];

%% Copy hackrf.h into src
copyfile('deps/include/Project/hackrf.h', 'src')

%% Copy new libhackrf.lib into 
copyfile('libhackrf/libhackrf.lib', 'deps/bin')

%% Compile
if isunix && ~any(ismember(varargin, '-v'))
    warning('off', 'MATLAB:mex:GccVersion_link');
end

fprintf('\nBuilding target ''%s'':\n', 'hackrf_find_devices.c');
mex(options{:}, 'src/hackrf_find_devices.c')

fprintf('\nBuilding target ''%s'':\n', 'hackrf_source.c');
mex(options{:}, 'src/hackrf_source.c', 'src/common.c')

fprintf('\nBuilding target ''%s'':\n', 'hackrf_sink.c');
mex(options{:}, 'src/hackrf_sink.c', 'src/common.c')

warning('on', 'MATLAB:mex:GccVersion_link');

%% Post
copyfile('src/hackrf_find_devices.m', BIN_DIR)
copyfile('blockset/hackrf_library.slx', BIN_DIR)
copyfile('blockset/slblocks.m', BIN_DIR)
copyfile('deps/bin/libhackrf.dll', BIN_DIR)

fprintf('\n--> Add "%s" to your MATLAB Path.\n', BIN_DIR);
