Docker for full GNU Linux build with buildroot for Licheepi nano board
    Kernel 5.12.19
    u-boot 2021.01-f1c100s-4 (from unframework)
    buildroot 2023.08.3
    gcc, g++  13.3
rootfs with gcc and g++ in 104Mb

bug 1
nol link in /lib/libgcc_s.so ->/lib/libgcc_s.so.1
need create this from console
cd /lib && ln -s ln -s ./libgcc_s.so.1 ./libgcc_s.so