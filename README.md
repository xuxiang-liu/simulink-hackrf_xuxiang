Simulink-HackRF_xuxiang
================
This forked Project supports higher Matlab Version (>R2016a). The rest is the same as the original project. https://github.com/kit-cel/simulink-hackrf

More features will be added in the future

Updated Build instructions for Microsoft Windows
----------------------------------------

Refer to my blog for more information: https://xuxiang-liu.github.io/2022/04/25/InstallHackrtWinEN.html

1. Install Mingw64 for Matlab

To double-check, open a MATLAB console:

		>> mex -setup C
		MEX configured to use 'MinGW64 Compiler (C)' for C language compilation.
		...

2. Get the Simulink-HackRF_xuxiang source from https://github.com/xuxiang-liu/simulink-hackrf_xuxiang. 

3. Extract the archive and create a subdirectory *deps* in there.

4. Build the *hackrf* library (based on (libhackrf README)[http://github.com/mossmann/hackrf/tree/master/host/libhackrf]):

    - First, get the hackrf source code by cloning the repo or download it as an archive and extract. Next, you need to install (CMake)[http://cmake.org/] as well as windows binaries for (libusb)[http://libusb.info/].

    - Start the CMake-GUI and set the source directory to your libhackrf sources, that is subdirectory 'host/libhackrf' in the repo. Create a directory 'build' in there and set it as the binaries directory in the CMake-GUI. Next, hit Configure and select 'MinGW Makefiles' as generator. Set the CMAKE_INSTALL_PREFIX to the 'deps' directory you created above. You will probably have to set the the include and lib settings for libusb manually: LIBUSB_INCLUDE_DIR must be set to the libusb directory, subfolder 'include/libusb-1.0'. LIBUSB_LIBRARIES can point to the static library shipped with the libusb binaries, 'MinGW64/static/libusb-1.0.a'. Finally, press Generate.

    - Open the *MinGW Command Prompt*, navigate to the 'libhackrf/build' directory and run ```mingw32-make``` to build the hackrf library. Next, run ```mingw32-make install```.

5. Get (Zadig)[http://zadig.akeo.ie/], plug-in your device and run Zadig and install the driver.

6. Run MATLAB, switch to your Simulink-HackRF directory and start the build process via

			>> make

7. After a refresh, you will find a new Toolbox named "HackRF" in the *Simulink Library Browser*. A simple spectrum scope model and a single-tone transmitter model is located in the directory *demos*. Also, there is MATLAB command ```>> hackrf_find_devices``` which you can use to test your setup.


Copyright
---------

The Simulink-HackRF interface consists of software from several authors. The following table lists all included software packages:

- *Simulink-HackRF*  
  Authors: Communication Engineering Lab (CEL), Sebastian Koslowski  
  License: GNU General Public License  
  Source:  https://github.com/kit-cel/simulink-hackrf
- *libhackrf* and *hackrf-tools*  
  Principal Author: Michael Ossmann  
  License: GNU General Public License  
  Source:  https://github.com/mossmann/hackrf

Contact and Support
-------------------

If you have further questions, please feel free to contact me:

- Xuxiang Liu (liuxuxiangbh@gmail.com)


