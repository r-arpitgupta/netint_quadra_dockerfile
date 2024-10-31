#!/bin/bash
echo "====== Initialize NETINT VPU Cards ======"
ni_rsrc_mon
echo "=== Done ==="
exec "$@"