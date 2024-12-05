#!/bin/bash -e
diff -ruN -x generated -x kernel -x scripts a c >a_c_kernel.patch
