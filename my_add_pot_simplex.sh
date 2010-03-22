#! /bin/bash
# 
# Copyright 2009 The VOTCA Development Team (http://www.votca.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ "$1" = "--help" ]; then
cat <<EOF
${0##*/}, version %version%
This script implemtents the Simplex Iteration step

Usage: ${0##*/} step_nr

USES: do_external for_all run_or_exit csg_get_interaction_property

NEEDS: name
EOF
   exit 0
fi

check_deps "$0"

main_dir=$(get_main_dir);
init_steps=$(wc -l $main_dir/simplex.in | awk '{print ($1)}');
step_nr=$(get_current_step_nr);
p_nr=$(grep -c '^p' simplex.cur);
p_line_nr=$(grep -n -m1 '^p' simplex.cur | sed 's/:.*//');

if [ $p_nr -gt "1" ] || [ $step_nr -eq $init_steps ]; then
for_all "non-bonded" \
   run_or_exit do_external par pot '$(csg_get_interaction_property name).dist.tgt \
   $(csg_get_interaction_property name).pot.new simplex.new' $(($p_line_nr-1))
else
for_all "non-bonded" \
   run_or_exit do_external par pot '$(csg_get_interaction_property name).dist.tgt \
   $(csg_get_interaction_property name).pot.new simplex.new' $init_steps
fi
