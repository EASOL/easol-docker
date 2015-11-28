FROM debian:jessie

# Copy FreeTDS && ODBC configuration files
COPY freetds.conf /etc/freetds/
COPY odbcinst.ini /etc/odbc/
COPY odbc.ini /etc/odbc/

RUN apt-get update && apt-get install -y \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Replace configuration placeholders with actual values
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux \
    && chmod +x /usr/local/bin/ep

CMD [ "/usr/local/bin/ep", "-v", "/etc/freetds/freetds.conf", "/etc/odbc/odbc.ini"]