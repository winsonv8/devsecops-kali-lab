# DevSecOps Kali Lab

An automated security-scanning lab built with Docker and GitHub Actions. Docker Compose starts a deliberately vulnerable web app (OWASP Juice Shop) and a custom Kali Linux scanner container. A CI pipeline builds the lab, runs Nmap and Nikto against the target on every push, and publishes the reports as build artifacts.

## Tech stack
Docker, Docker Compose, Kali Linux, Nmap, Nikto, GitHub Actions, OWASP Juice Shop

## Architecture
- `Dockerfile`: Kali image with Nmap and Nikto pre-installed
- `docker-compose.yml`: Juice Shop target plus Kali scanner on one private network
- `.github/workflows/scan.yml`: CI pipeline (build, scan, upload reports, tear down)
- `reports/`: scan output (ignored by Git, saved as pipeline artifacts instead)

## Run locally
    docker-compose up -d --build
    docker exec kali-scanner nmap -Pn -p 3000 --script http-title,http-headers juice-shop -oN /reports/nmap.txt
    docker exec kali-scanner nikto -h http://juice-shop:3000 -maxtime 120s -o /reports/nikto.txt -Format txt
    docker-compose down

## CI pipeline
Runs on every push to `main` and can be started manually from the Actions tab. Steps: checkout, build and start the lab, run Nmap, run Nikto, upload the `scan-reports` artifact, tear down.

## What I learned
- Containers on the same Compose network reach each other by service name.
- Container file permissions on mounted volumes can break CI runs.
- CI failures can come from flaky external mirrors, so builds should retry downloads.

## Roadmap
- Add OWASP ZAP scanning
- Fail the build on high-severity findings
- Provision the lab with Terraform or Ansible

## Ethics
Only scan systems you own or intentionally vulnerable labs like Juice Shop.

## Sample findings (Juice Shop)
OWASP ZAP baseline: 0 High, 2 Medium, 4 Low, 3 Informational.

- Medium: Content Security Policy (CSP) header not set
- Medium: Cross-domain misconfiguration (wildcard CORS)
  
Nikto independently flagged the same wildcard CORS header, missing security headers, and an exposed /ftp/ directory.
