#!/bin/bash
. /opt/conda/etc/profile.d/conda.sh
conda activate webshop
python -m web_agent_site.app --log
