# Start process with `sudo make`
DAEMON_NAME=daemon_name
STARTUP_FILE=~/daemon_name/main.py  # Set path to startup file of your project
EXECUTOR=python3  # Set start utility. Use full path to bin for virtual environments
RESTART=always  # One of [always, on-abort]. With `on-abort` daemon will not start after manual or normal exit.

define UNIT_FILE
[Service]
ExecStart=$(EXECUTOR) $(STARTUP_FILE)
Restart=$(RESTART)

[Install]
WantedBy=multi-user.target

endef

all: create_unit start_unit enable
	view_status

create_unit:
	$(file > /etc/systemd/system/$(DAEMON_NAME).service, $(UNIT_FILE))

delete_unit:
	rm /etc/systemd/system/$(DAEMON_NAME).service

start_unit:
	systemctl start $(DAEMON_NAME)

view_status:
	systemctl status $(DAEMON_NAME)

# Enable autostart with OS
enable:
	systemctl enable $(DAEMON_NAME)

# Disable autostart with OS
disable:
	systemctl disable $(DAEMON_NAME)

# Display retro log of daemon. Add `-f -u` tags to show realtime journal
show_journal:
	journalctl -u $(DAEMON_NAME)