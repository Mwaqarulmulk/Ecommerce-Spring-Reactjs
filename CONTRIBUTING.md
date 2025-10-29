# Contributing

Thanks for wanting to contribute! This repository uses a simple workflow so external collaborators can quickly get started.

Required setup
- Install Git, Java 21 (for backend), Maven, Node 18+ (for frontend), and Docker if you use the containerized setup.
- Authenticate with GitHub (recommended: `gh auth login`).

Recommended branch & PR workflow
1. Fork the repository (if you don't have push access) or create a feature branch directly on this repo:
   - git checkout -b feat/<short-description>
2. Make small, focused commits with descriptive messages.
3. Push your branch and open a Pull Request against `master`.
4. Add the reviewer(s) or `@ghulam-mujtaba5` as a reviewer. If you have a CODEOWNERS entry, GitHub will request review from the owner.

Code style and tests
- Keep changes small and add unit tests where appropriate.
- For backend: run `./mvnw test`.
- For frontend: run `npm install` and `npm run dev` (or `npm run build`).

Environment / secrets
- Do not commit secrets. Use environment variables for DB credentials and JWT secrets. A `.env.sample` file describes the variables used.

Getting help
- If you need access or an invite, ask a maintainer to add you as a collaborator on GitHub.

Thanks for contributing!
