# Start process with `sudo make`
DAEMON_NAME=test_daemon
STARTUP_FILE=/opt/test_daemon/main.py  # Set path to startup file of your project
EXECUTOR=python3  # Set start utility. Use full path to bin for virtual environments
RESTART=on-abort  # One of [always, on-abort]. With `on-abort` daemon will not start after manual or normal exit.

define UNIT_FILE
[Service]
ExecStart=$(EXECUTOR) $(STARTUP_FILE)
Restart=$(RESTART)

[Install]
WantedBy=multi-user.target

endef

all: create_unit enable start status

create_unit:
        $(file > /etc/systemd/system/$(DAEMON_NAME).service, $(UNIT_FILE))

delete_unit:
        rm /etc/systemd/system/$(DAEMON_NAME).service

start:
        systemctl start $(DAEMON_NAME)

stop:
        systemctl stop $(DAEMON_NAME)

status:
        systemctl status $(DAEMON_NAME)

# Enable autostart with OS
enable: create_unit
        systemctl enable $(DAEMON_NAME)

# Disable autostart with OS
disable:
        systemctl disable $(DAEMON_NAME)

# Display log of daemon since server startup.
# Add `-f` before `-u` to show realtime journal.
# Delete `-b` to show alltime logs.
log:
        journalctl -b -u $(DAEMON_NAME)