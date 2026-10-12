# Client Setup Supplements

This directory contains client-specific additions to the public Aident Loadout setup guide. The monorepo sync
publishes it to `Aident-AI/aident-skill` alongside the static Skill.

The shared setup source remains `apps/web/src/app/SETUP.md/content.md` in the monorepo. A client route inserts one
supplement at `{{AIDENT_CLIENT_SETUP_INSTRUCTIONS}}` and uses the shared response renderer. Keep installation,
update, environment, and general authentication instructions in the shared source.

- [Muse](clients/muse.md) is composed into `https://aident.ai/muse/SETUP.md`.

These files are setup source, outside `skills/aident-skill/`. They do not add another discoverable Skill or change
the immutable installable Skill package. Do not copy the shared guide into a client supplement.
