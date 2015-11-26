FROM debian:jessie

# Copy FreeTDS configuration files
COPY freetds.conf /etc/freetds/freetds.conf

RUN apt-get update && apt-get install -y \
        curl

# Replace configuration placeholders with actual values
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux \
    && chmod +x /usr/local/bin/ep

CMD [ "/usr/local/bin/ep", "-v", "/etc/freetds/freetds.conf"]
