cat > ~/install_nrb.sh <<'BASH'
#!/usr/bin/env bash
set -e

ZIP="$HOME/Downloads/NRB_PROXMOX_V1_ADMIN_OWN_VPS.zip"
DIR="$HOME/NRB_PROXMOX_V1"

echo "=================================="
echo "     NRB PROXMOX V1 INSTALLER"
echo "=================================="

if [ ! -f "$ZIP" ]; then
    echo "ERROR: ZIP not found: $ZIP"
    echo "Put the downloaded ZIP in your Downloads folder."
    exit 1
fi

sudo apt update
sudo apt install -y unzip python3 python3-venv python3-pip

mkdir -p "$DIR"
unzip -oq "$ZIP" -d "$DIR"

cd "$DIR"

if [ ! -f requirements.txt ]; then
    echo "ERROR: requirements.txt not found."
    exit 1
fi

python3 -m venv venv
source venv/bin/activate

python -m pip install --upgrade pip
pip install -r requirements.txt

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
    else
        echo "ERROR: .env.example not found."
        exit 1
    fi
fi

echo ""
echo "Installation complete!"
echo "Project: $DIR"
echo "Configure your Proxmox settings in:"
echo "$DIR/.env"
echo ""
echo "Starting NRB PROXMOX V1..."
echo ""

flask --app wsgi:app run --host 0.0.0.0 --port 5000
BASH

chmod +x ~/install_nrb.sh
bash ~/install_nrb.sh
