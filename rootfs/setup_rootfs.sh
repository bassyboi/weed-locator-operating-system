# Optimize memory usage with zram
echo "Setting up zram..."
sudo apt-get install -y zram-tools
echo "zram-config" | sudo tee -a /etc/modules

# Reduce swap usage
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf

# Disable unnecessary services
systemctl disable bluetooth.service
systemctl disable avahi-daemon.service

# Use a lightweight init system if needed (optional)
# Consider replacing systemd with alternatives like runit or s6

