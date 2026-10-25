# DevSecOps Kali Lab

An automated security-scanning lab. Docker Compose starts a deliberately vulnerable app (OWASP Juice Shop) and a custom Kali Linux scanner container. A GitHub Actions pipeline builds the lab, runs Nmap and Nikto on every push, and publishes the reports as build artifacts.

## Architecture
- `Dockerfile`: Kali image with Nmap and Nikto pre-installed
- `docker-compose.yml`: Juice Shop target plus Kali scanner on one network
- `.github/workflows/scan.yml`: CI pipeline (build, scan, upload reports, tear down)

## Run locally
    docker-compose up -d --build
    docker exec kali-scanner nmap -sV -p 3000 juice-shop -oN /reports/nmap.txt
    docker exec kali-scanner nikto -h http://juice-shop:3000 -maxtime 120s -o /reports/nikto.txt -Format txt
    docker-compose down

## Pipeline
Runs automatically on every push to `main`. Reports are saved as the `scan-reports` artifact in the Actions tab.

## Ethics
Only scan systems you own or intentionally vulnerable labs like Juice Shop.
