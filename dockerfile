FROM debian:buster-slim

# Adapted from https://github.com/tentone/tello-ros2

COPY scripts/install.sh /bootstrap.sh
RUN ["/bin/bash", "-c", "bash bootstrap.sh"]
