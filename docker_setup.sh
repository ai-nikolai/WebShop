#!/bin/bash
. /opt/conda/etc/profile.d/conda.sh
conda activate webshop

# Patching up the Docker environment
ln -s /opt/conda/envs/webshop/lib/libmkl_core.so /opt/conda/envs/webshop/lib/libmkl_core.so.1
ln -s /opt/conda/envs/webshop/lib/libmkl_intel_lp64.so /opt/conda/envs/webshop/lib/libmkl_intel_lp64.so.1
ln -s /opt/conda/envs/webshop/lib/libmkl_gnu_thread.so /opt/conda/envs/webshop/lib/libmkl_gnu_thread.so.1
# this is needed to run the following things
pip install Werkzeug==2.2.2 numpy==1.24.4




# Download dataset into `data` folder via `gdown` command
mkdir -p data
cd data

# Download full dataset
gdown https://drive.google.com/uc?id=1A2whVgOO0euk5O13n2iYDM0bQRkkRduB # items_shuffle
gdown https://drive.google.com/uc?id=1s2j6NgHljiZzQNL3veZaAiyW_qDEgBNi # items_ins_v2
gdown https://drive.google.com/uc?id=14Kb5SPBk_jfdLZ_CDBNitW98QLDlKR5O # items_human_ins
cd ..

# Build search engine index
cd search_engine
mkdir -p resources resources_100 resources_1k resources_100k
python convert_product_file_format.py # convert items.json => required doc format
mkdir -p indexes
./run_indexing.sh
cd ..

# Create logging folder + samples of log data
mkdir -p user_session_logs/
cd user_session_logs/
# Create logging folder + samples of log data
PYCMD=$(cat <<EOF
import gdown
url="https://drive.google.com/drive/u/1/folders/16H7LZe2otq4qGnKw_Ic1dkt-o3U9Zsto"
gdown.download_folder(url, quiet=True, remaining_ok=True)
EOF
)

python -c "$PYCMD"
echo "Downloading example trajectories complete"
cd ..