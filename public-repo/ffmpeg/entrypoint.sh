#!/bin/bash
echo "====== Initialize NETINT VPU Cards ======"
ni_rsrc_mon -t 5
echo "=== Done ==="
exec "$@"