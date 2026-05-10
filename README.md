# README.md

# UWAZI Platform

## Kenya Public Projects Accountability System

**Transforming public project monitoring through radical transparency, citizen participation, and digital accountability.**

UWAZI is an open-source civic technology platform designed to improve transparency and accountability in public project implementation across Kenya.


## Vision

To empower citizens, oversight bodies, and government institutions with real-time, verifiable, and accessible public project data.


## Core Features

### Project Registry & Lifecycle Tracking
- Register public projects
- Track implementation stages
- Geo-location mapping

### Budget Transparency Engine
- Line-item budgets
- Disbursement tracking
- Financial anomaly detection

### Citizen Verification System
- Photo/video evidence uploads
- Geo-tagged reports
- Community validation

### Contractor Accountability Registry
- Contractor profiles
- Performance scorecards
- Compliance checks

### Complaints & Escalation Module
- Structured complaint filing
- SLA tracking
- Oversight routing

### Offline Accessibility
- USSD integration
- SMS reporting
- Lightweight mobile access
```
## Tech Stack

### Frontend
- Next.js/React.js
- Tailwind CSS
- TypeScript/Javascript

### Backend
- Node.js/django
- Express.js
- Prisma ORM
```
### Database
- MySQL
- Redis
```
### Infrastructure
- Docker
- GitHub Actions

---
```

## Getting Started

### Clone Repository


git clone https://github.com/yourusername/uwazi-platform.git
cd uwazi-platform

```
### Install Dependencies

```bash
npm install
```

### Start Development Server


npm run dev


---

## Team Workflow

* `main` → Production-ready code
* `develop` → Integration branch
* `feature/*` → Individual feature development

## License

MIT License

````
# Folder Structure


uwazi-platform/
│
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── app/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── lib/
│   │   └── styles/
│   └── package.json
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── routes/
│   │   ├── services/
│   │   └── utils/
│   └── package.json
│
├── database/
│   ├── migrations/
│   ├── schema.prisma
│   └── seed.ts
│
├── docs/
│   ├── proposal/
│   ├── architecture.md
│   └── api-spec.md
│
├── api/
│   └── openapi.yaml
│
├── mobile/
│   └── ussd/
│
├── scripts/
│
├── .github/
│   └── workflows/
│
├── .env.example
├── docker-compose.yml
├── README.md
├── LICENSE
└── CONTRIBUTING.md

# .gitignore


node_modules/
.env
.next/
dist/
build/
coverage/
*.log
.vscode/
.DS_Store

# CONTRIBUTING.md

# Contributing to UWAZI

## Workflow

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push branch
5. Open Pull Request

## Branch Naming

- feature/module-name
- fix/bug-description
- docs/update-name

## Commit Style

- feat:
- fix:

- docs:
- refactor:

````

