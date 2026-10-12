## Muse-Specific Setup

Use this supplement when the user asks to set up Aident Loadout in Meta's Muse personal agent. Read the complete
document before acting. Follow the shared setup stages below with these Muse adaptations. This is distinct from
the Muse Code terminal client.

### Verify Existing Access First

Check `aident --version` and, when the CLI is available, run `aident whoami --json` and `aident doctor --json`.
If authentication is valid, show the signed-in account so the user can confirm it is theirs, and reuse that login.
Do not request another sign-in or rerun the bootstrap installer when the verified CLI is already ready. Continue
through the shared idempotent setup engine, which can reuse that login while verifying and recording setup. If the
account is not the user's intended account, ask before signing out or replacing it. Check current setup status from
command results, not from an earlier conversational claim.

### Install And Authenticate In Muse's Cloud Environment

Run the shared CLI bootstrap in Muse's persistent cloud environment, not on the user's phone or laptop. Confirm the
installed `aident` executable is accessible to the current worker. Keep the verified static Skill installed by the
shared setup engine; do not create a second copy of its instructions.

For Stage 3, identify the current client as `Muse`. When authentication is needed in a remote worker, prefer the
shared OOB flow so the user can sign in through a browser on their own device:

```bash
aident setup --base-url "{{AIDENT_SETUP_BASE_URL}}" --client-name "Muse"{{AIDENT_AFFILIATE_REF_FLAG}}{{AIDENT_ONBOARDING_SESSION_FLAG}} --oob --json
```

Present the returned sign-in link and wait for the user to complete authorization. Use Muse's supported secure
credential flow when available. Do not ask the user to paste passwords, API keys, access tokens, or refresh tokens
into the conversation. Follow the shared OOB instructions for the temporary verification code. Do not claim the
CLI credential file is automatically integrated with Muse's Secure Credentials Store; report a credential-storage
or refresh limitation if the host prevents the normal flow. Verify the resulting identity with `aident whoami --json`.

If Muse blocks a remote document, installer, or network request, report the exact error and request the relevant
host approval through its supported UI. Do not bypass a security block or claim installation completed without
successful command results.

### Make Access Reusable Through Muse

Muse supports custom connectors for services with APIs or CLIs. Aident CLI access does not depend on an Aident tile
appearing in Muse's built-in connector list. Do not claim that this setup publishes an approved native connector.

The current shared onboarding mappings do not include Muse. For Stage 4, do not select another client's adapter or
guess a global instruction path. Report that the CLI-managed Muse routing transaction is unsupported, then use
Muse's supported custom connector or reusable Skill workflow if it is available in this environment.

Save only non-secret setup information: how to locate the installed Aident CLI and verified static Skill, that
external tasks should start with Loadout discovery, and how to check authentication and Vault readiness before
executing Actions. Refer to the installed `aident-skill` for live schemas, execution, approvals, and audit guidance.
Do not duplicate the shared setup document or store credentials in a Skill, memory, or artifact.

Verify that a fresh Muse chat and a separate worker can find the CLI, use the intended authenticated account, and
execute a read-only Action. Use the same supported credential mechanism across workers; do not copy tokens through
chat. If either check cannot be run, say it is unverified. Do not claim future-session or worker reuse merely because
the current chat succeeded. If Muse has no supported reusable connector mechanism, report current-session CLI
access separately from persistent setup.

### Connect Apps And Demonstrate Results

After verifying sign-in, run `aident vault status --json`. Explain briefly what Loadout can do using available
capabilities. Distinguish Aident-managed tools that are ready without separate provider sign-in from the user's own
connected app accounts. A ready managed tool does not mean the user's Gmail, Slack, or other personal app is
authorized.

Use capability search and live schemas to find the apps the user wants to try. For apps requiring user authorization,
check the specific Vault state, start the supported Vault connection flow, and guide the user through consent.
Read back readiness before execution. Do not ask for raw provider secrets in chat or assume every Integration uses
OAuth; follow the live connection schema and the user's authorized scope.

Run small read-only demonstrations through two or three different ready Integrations and show the actual results or
exact errors. Follow the installed Skill's cost and approval rules. Reuse relevant successful Action results from
this setup attempt instead of repeating billable demonstrations. Explain a few useful tasks based on the validated
apps only after sign-in and readiness checks.

### Report Verified Completion

Use the shared completion structure, but replace its cross-agent routing statement with the actual Muse result:
CLI authentication, intended account, ready managed tools, connected personal apps, successful Action tests, and
whether reusable connector registration, fresh-chat access, separate-worker access, and later authentication refresh
were verified. Keep any unsupported or untested part explicit. Give the user the Muse setup URL for later setup or
update requests: `https://aident.ai/SETUP.md`.

### Muse References

- [Meta's connector guide](https://www.meta.com/help/artificial-intelligence/1687253048996149/) describes custom connectors.
- [Muse's architecture](https://research.meta.ai/blog/security-and-safety-for-ai-agents-our-approach-with-muse) describes its cloud computer, secure credentials, and host approval controls.
