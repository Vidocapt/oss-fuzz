#!/bin/bash -eux
# Copyright 2017 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Builds fuzzers from within a container into /out/ directory.
# Expects /src/cras to contain a cras checkout.

cd ${SRC}/adhd/cras
./git_prepare.sh
./configure --disable-DBUS
make -j$(nproc)

$CXX $CXXFLAGS $FUZZER_LDFLAGS \
  ${SRC}/adhd/cras/src/fuzz/rclient_message.cc -o ${OUT}/rclient_message \
  -I ${SRC}/adhd/cras/src/server \
  -I ${SRC}/adhd/cras/src/common \
  ${SRC}/adhd/cras/src/.libs/libcrasserver.a \
  -lpthread -lrt -ludev -ldl -lm \
  -lFuzzingEngine \
  -Wl,-Bstatic -liniparser -lasound -lspeexdsp -Wl,-Bdynamic
