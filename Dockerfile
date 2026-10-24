FROM kalilinux/kali-rolling
RUN apt-get update && \
    apt-get install -y --no-install-recommends nmap nikto curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /reports
CMD ["sleep", "infinity"]
