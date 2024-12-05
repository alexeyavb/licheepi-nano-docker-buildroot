#!/bin/bash -e
diff -ruN -x generated -x kernel -x scripts a b >kernel.patch
