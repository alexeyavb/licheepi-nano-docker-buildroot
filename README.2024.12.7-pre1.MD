Docker for full GNU Linux build with buildroot for Licheepi nano board
    Kernel 5.12.19
    u-boot 2021.01-f1c100s-4 (from unframework)
    buildroot 2023.08.3
    gcc, g++  13.3
rootfs with gcc and g++ in 104Mb

bug 1
nol link in /lib/libgcc_s.so ->/lib/libgcc_s.so.1
need create this from console
/code

    cd /lib \
	&& ln -s ln -s ./libgcc_s.so.1 ./libgcc_s.so \
        && ln -s ./libdl.so.2 ./libdl.so \
        && ln -s ./libc.so.6 ./libc.so \
        && ln -s ./librt.so.1 ./librt.so \
        && ln -s ./libthread_db.so.1 ./libthread_db.so \
        && ln -s ./libutil.so.1  ./libutil.so

code/