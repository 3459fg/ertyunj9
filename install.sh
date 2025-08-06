#!/bin/bash
# X-Breach-Forensic-Toolkit Installer
# Author: DarkForge-X (Ethical Use Only)
# Tested on Kali Linux 2024.1

# ===== LEGAL DISCLAIMER =====
echo "[!] WARNING: This toolkit is for AUTHORIZED PENETRATION TESTING ONLY."
echo "    Unauthorized use violates international cybersecurity laws."
sleep 2

# ===== DEPENDENCY INSTALLATION =====
echo "[+] Updating packages and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    python3-pip \
    python3-dev \
    golang \
    tor \
    git \
    libssl-dev \
    jq  # For JSON parsing in future modules

# ===== PYTHON MODULES =====
echo "[+] Installing Python requirements..."
pip3 install --upgrade pip
pip3 install -r requirements.txt

# ===== GO SETUP =====
echo "[+] Configuring Go environment..."
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
go env -w GO111MODULE=auto

# Install Go dependencies
echo "[+] Fetching Go packages..."
go get golang.org/x/net/proxy  # Tor support for credstuff-x
go get github.com/stretchr/testify  # Testing framework

# ===== TOOL COMPILATION =====
echo "[+] Building credstuff-x..."
cd credstuff-x/
go build -o ../bin/credstuff-x
cd ..

# ===== DIRECTORY STRUCTURE =====
echo "[+] Creating analysis directories..."
mkdir -p \
    ./data/raw \
    ./data/processed \
    ./logs \
    ./output

# ===== TOR PROXY CONFIG =====
echo "[+] Verifying Tor service..."
if ! systemctl is-active --quiet tor; then
    echo "[!] Tor not running - starting service..."
    sudo systemctl start tor
    sudo systemctl enable tor
fi

# ===== PERMISSIONS =====
echo "[+] Setting file permissions..."
chmod -R 750 ./bin
chmod 644 ./data/*

# ===== VALIDATION =====
echo "[+] Running sanity checks..."

# Check Python
python3 -c "import pandas; print('[+] Pandas version:', pandas.__version__)" || exit 1

# Check Go
go version || { echo "[!] Go installation failed"; exit 1; }

# Verify Tor SOCKS proxy
curl --socks5-hostname localhost:9050 -s https://check.torproject.org/api/ip | jq .IsTor || \
    { echo "[!] Tor proxy test failed"; exit 1; }

# ===== COMPLETION =====
cat << "EOF"

[+] INSTALLATION COMPLETE
---------------------------------
Toolkit ready. Commands:
  * Data analysis: python3 x_breach_verifier.py -d <dataset>
  * Cred testing: ./bin/credstuff-x <targets.csv>
  * Tor restart:  sudo systemctl restart tor

WARNING: ALWAYS obtain proper authorization before testing.
EOF
