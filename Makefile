# Start process with `sudo make`
DAEMON_NAME=echobot-example
STARTUP_FILE=/opt/echobot-example/bot.py  # Set path to startup file of your project
EXECUTOR=python3  # Set start utility
RESTART=always  # One of [always, on-abort]. With `on-abort` daemon will not start after manual or normal exit.

define SERVICE_FILE
[Service]
ExecStart=$(EXECUTOR) $(STARTUP_FILE)
Restart=$(RESTART)

[Install]
WantedBy=multi-user.target

endef

all: create_service_file

create_service_file:
	$(file > /etc/systemd/system/$(DAEMON_NAME).service, $(SERVICE_FILE))