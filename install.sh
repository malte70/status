#!/usr/bin/env bash



# Install optional dependencies? 1=yes
INSTALL_SH_OPTIONAL=0



# 
# Install dependencies
# 
sudo apt-get install \
	netcat-openbsd \
	curl \
	git



# 
# Optional dependencies
# 
if [[ $INSTALL_SH_OPTIONAL -eq 1 ]]; then
	
	sudo apt-get install \
		links 
	
	if ! which pushover-notify &>/dev/null
	then
		sudo wget \
			-O "/usr/local/bin/po-notify.pyz" \
			"https://f.malte70.de/po-notify.pyz"
		sudo ln -s \
			"po-notify.pyz" \
			"/usr/local/bin/pushover-notify"
		sudo chmod +x \
			"/usr/local/bin/pushover-notify"
	fi
fi



# 
# Show some instructions for setting up the required SSH keys
# and a cronjob, which are not set up by install.sh.
# 
cat <<EOF
==> Installed all requirements.

==> Now you need to manually copy your SSH deploy keys to the expected path:
    --> $HOME/.ssh/id_tinystatus
    --> $HOME/.ssh/id_tinystatus.pub

==> Last but not least: Add a cronjob.
	--> Run "crontab -e" to open your crontab in your default editor
	--> Add the following line, and replace /opt/status with the path to
	    your clone of the Git repository:

# Generate new status page every 6 hours
0 */6 * * * /usr/bin/env /opt/status/run.sh upload

EOF

