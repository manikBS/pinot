#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#


PID_DIR="pids"

if [ ! -d "$PID_DIR" ]; then
  echo "No PID directory found. Are the services running?"
  exit 1
fi

stop_service() {
  local name=$1
  local pid_file="$PID_DIR/$name.pid"

  if [ -f "$pid_file" ]; then
    PID=$(cat "$pid_file")
    if ps -p $PID > /dev/null 2>&1; then
      echo "Stopping $name (PID: $PID)..."
      kill $PID
      rm -f "$pid_file"
      echo "$name stopped."
    else
      echo "$name not running (stale PID file: $pid_file)"
      rm -f "$pid_file"
    fi
  else
    echo "No PID file for $name."
  fi
}

stop_service "broker"
stop_service "controller"
