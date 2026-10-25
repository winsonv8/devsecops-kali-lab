FROM kalilinux/kali-rolling
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80retries && \
    apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing nmap nikto curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /reports
CMD ["sleep", "infinity"]
