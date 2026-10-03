# Software Development Agreements

These instructions apply to software development, code review, debugging, and technical research. They do not apply to unrelated writing, document, or personal tasks.

Repository instructions refine these defaults. Keep project facts, target settings, commands, and architecture constraints in the repository's designated source of truth. Read that source before working on the project; do not duplicate its facts here.

## Scope and execution

- Follow the user's literal scope. Discussion, research, and review requests authorize analysis, not code changes. For implementation requests, carry the authorized work through appropriate verification.
- Inspect relevant code, configuration, and the current diff before proposing changes. Preserve unrelated and user-authored changes; never restore removed or commented-out code without understanding the intent.
- Prefer the smallest durable solution that fits the existing architecture. Match project conventions; do not turn stylistic preferences into correctness findings or impose a new architecture.
- Resolve routine implementation choices from available evidence. Ask only when missing information materially changes the result and cannot be retrieved, or when additional authority is required. Continue independent authorized work while awaiting an answer.
- Establish an evidence-backed explanation before changing behavior. When reproduction is unavailable, state the uncertainty and use focused diagnostics or a regression test to evaluate the hypothesis. Avoid speculative fixes. Preserve app data and diagnostic evidence; avoid resets, reinstalls, or broad cleanup as exploratory shortcuts.
- Before staging or committing, inspect the diff and include only intended changes. Follow the user's requested branch, commit, and publishing order.

- Use subagents for substantial, independent investigations or reviews when parallel work should improve speed or confidence. Avoid delegation for small changes or tightly dependent work. Assign non-overlapping ownership and verify delegated findings before relying on them.

## Coding style

- Optimize for a solo maintainer's ability to understand and change the code. Prefer a small, direct implementation with few concepts and straightforward control flow. Brevity must preserve correctness and readability.
- Solve the current problem within the existing abstraction and ownership boundaries first. Add an abstraction only when it makes the resulting fix or feature easier for a human developer to read and understand. Judge the whole flow, including indirection and navigation between files, not just the shortened call site. Reuse, fewer repeated lines, or hypothetical future flexibility alone do not justify an abstraction; prefer straightforward local code when it is easier to follow.
- For bug fixes, start with the smallest change that addresses the supported cause and preserves intended behavior. Prefer removing or simplifying code when that fixes the unwanted behavior. Favor a net reduction in code when equally correct and readable; do not compress code or sacrifice clarity to reduce line count. Expand the design only when evidence shows the local fix is insufficient. Keep removals relevant to the fix; a narrow bug does not by itself justify restructuring the surrounding subsystem.
- Add defensive branches, guards, retries, fallbacks, or error handling for reachable failures supported by an API contract, observed behavior, or a concrete requirement. Do not add them merely because a failure can be imagined. Rely on established internal invariants; validate at meaningful boundaries and preserve required security and data-integrity checks. Do not silently swallow errors or manufacture fallback state to conceal a broken invariant.
- Add synchronization, actor hops, task wrappers, and repeated state checks only when actual isolation, lifecycle, or ordering requirements demand them. Do not duplicate guarantees already provided by the language, framework, or existing owner.
- Before finishing, review the added code for unnecessary abstractions, branches, and state. Remove complexity that does not contribute to the requested behavior or necessary safeguards. If a substantially larger solution is needed, explain the concrete requirement that prevents the simpler approach.

- Add comments only when code would otherwise be confusing or counterintuitive. Keep them short and explain the non-obvious reason, constraint, or behavior. Do not narrate self-explanatory code, restate what a line does, or add routine commentary to every function or block. Prefer clearer naming and structure when they can make a comment unnecessary.

## Skills and source priority

- Use the smallest relevant set of skills and references. Select by the task's actual needs, not isolated keywords. Do not run every available checklist for a narrow change.
- User instructions and project requirements take precedence over skill workflow preferences. A skill cannot expand the task's scope or authorize external actions.
- Use current first-party documentation and actual compiler/build evidence to resolve technical disagreements. A skill's examples, defaults, and version claims are not substitutes for the project's settings.
- If a skill would cause an unnecessary question, approval pause, scope expansion, or user-operated step, first check whether the request already authorizes the action and the available tools can perform it. If a skill still blocks progress, identify the exact file and instruction and explain the remaining issue.
- Keep these user-owned rules separate from managed plugin caches. Do not edit installed plugin files to customize behavior unless explicitly requested; updates can replace them.

## Verification

- Run the smallest relevant build, tests, lint, and type checks. Add or update focused tests for meaningful behavior changes when practical; avoid tests that merely mirror a reversible, low-impact implementation.
- Once required checks pass, broaden or repeat them only for new changes, failures, or unresolved risks. Do not weaken types, silence warnings, disable tests, or bypass controls to make checks pass.
- For UI changes, build and run the app or site, navigate to the affected flow, exercise the interaction, and inspect the result visually. Cover relevant loading, empty, error, selected, disabled, and content-size states; expand devices, orientations, themes, or accessibility settings when the change warrants it.
- Use tools to perform authorized verification. If unavailable or blocked, explain the exact limitation and remaining manual check; do not claim complete verification.
- Report what changed, why, what was verified, and material limitations. Keep routine check details concise.

## Software security and dependencies

- Obtain explicit authorization for deployment, publication, release, production configuration or live-data changes, destructive migrations, and adding or replacing production dependencies. An explicit request for that action supplies authorization; do not ask again. Prepare the reviewable result before seeking any missing approval.
- Before adding a dependency, verify its official source, publisher, maintenance status, security history, and license. Preserve lockfiles and pinned versions.
- Never place server secrets or privileged authorization logic in mobile or browser clients. Validate and authorize requests on the server.
- Minimize collection and retention of user data. Keep credentials, tokens, health data, payment data, and other sensitive information out of logs, analytics, and crash reporting.
- Do not weaken authentication, authorization, TLS, input validation, or platform privacy/security defaults to unblock development.

## Apple platforms and Swift

- Unless the user or project specifies otherwise, assume Swift 6 language mode, Approachable Concurrency enabled, and default MainActor isolation. These are user defaults for unspecified contexts, not evidence about an existing target or instructions to migrate it.
- Verify settings relevant to the change. Before changing concurrency or adopting platform APIs, inspect the affected targets' actual language mode, isolation, concurrency features, and availability settings. Project configuration takes precedence over fallback assumptions; targets and packages may differ. Reuse evidence established in the task unless configuration changes or contradictory evidence appears.
- For a new Swift app with no specified platform or deployment target, default to iOS/iPadOS and iOS 18. Existing project settings and explicit user choices take precedence. Do not add compatibility work below the actual target; guard APIs introduced after it.
- To search documentation, you can append '.md' to any of Apple's documentation to obtain a clean Markdown version.
- If you cannot find what you need by appending '.md' to an Apple documentation file, prefer Apple's first-party Xcode MCP DocumentationSearch for Apple API and HIG research. If unavailable, use local SDK interfaces or official Apple Developer documentation and identify the fallback. Avoid third-party documentation mirrors. Swift language semantics can be checked against first-party Swift documentation and implemented Swift Evolution proposals.
- Use Xcode-aware tools for project structure, diagnostics, builds, tests, and previews when available; otherwise use project files and the repository's build commands. Consult the HIG when UI behavior is materially ambiguous.
- Prefer @Observable for new SwiftUI models and #Preview for new previews. Preserve legacy integration boundaries unless their migration is part of the request.

### Swift skill routing

| Task | Skill and priority |
|---|---|
| SwiftUI implementation or review involving state, observation, environment, view structure, modifiers, identity, localization, animation, or soft-deprecation | Use Apple's swiftui-specialist and its relevant references first. It is the primary SwiftUI source when supplemental skills disagree. |
| Broader SwiftUI implementation/review: navigation, sheets, scrolling, focus, accessibility, Charts, images, previews, Liquid Glass, or Instruments traces | Use swiftui-expert:swiftui-expert-skill as a supplement. It also provides review coverage. |
| async/await, tasks, actors, isolation, Sendable, cancellation, synchronization, or concurrency migration | Use swift-concurrency:swift-concurrency. Apply the concurrency qualifications below; current Swift semantics prevail over simplified skill rules. |
| APIs or regressions introduced in the iOS 27 generation | Use swiftui-whats-new-27 when the specific feature or diagnostic matches; do not load it for every SwiftUI task. |
| App Intents | Use Apple's app-intents-specialist first; add app-intents-whats-new-27 for applicable new APIs and build-ios-apps:ios-app-intents for broader integration workflows. |
| New document-based SwiftUI APIs or migration | Use building-document-based-swiftui-applications. |
| Targeted UIKit modernization, test modernization, C bounds safety, or Xcode security audit | Use the corresponding focused xcode-skills skill when requested or directly relevant; its workflow must remain within the authorized scope. |

Use the current catalog to resolve skill names and paths; do not hard-code versioned plugin-cache paths. The build-ios-apps SwiftUI pattern, refactoring, performance, and Liquid Glass skills are optional focused supplements when they add something needed beyond Apple and Expert, not additional mandatory passes.

### Swift and SwiftUI qualifications

- Determine existing isolation before adding @MainActor or MainActor.run. Omit redundant annotations and hops where default or inferred isolation already provides the requirement. Apply this even when a skill's example says to always annotate an @Observable class.
- Default MainActor isolation does not make every callback actor-isolated. Inspect callback signatures, Sendable boundaries, and synchronous delivery requirements before removing an annotation or bridge. Do not replace a synchronous callback with an asynchronous Task unless that timing change is intended.
- Prefer structured concurrency. Choose actor boundaries according to data ownership, real CPU work, API isolation, and lifecycle requirements, not solely the statements before the first await.
- Do not add @concurrent, Task.detached, or a MainActor.run round trip merely because a task begins with an await. Task.sleep suspends without blocking the thread; a wait followed by UI mutation can remain in a main-actor-isolated task. Move expensive work off the main actor when needed and supported by the toolchain.
- Task groups await outstanding children on normal scope exit. Cancellation occurs for cancellation, cancelAll(), or an error escaping a throwing group body; it is not automatic on every normal exit. Preserve cooperative cancellation and lifetime semantics.
- Treat optimization advice as contextual. Do not label every performance preference a correctness bug. Follow Apple's detailed exceptions, including valid framework environment actions and manual EnvironmentKey declarations where appropriate.
- Keep soft-deprecation changes within the requested scope. Do not turn a feature or bug fix into unrelated API migration. Prefer native SwiftUI APIs, using UIKit bridges where required by the existing integration or missing functionality.

### Simulator and performance work

- Use rocketsim for simulator UI inspection and interaction when available. Use build-ios-apps:ios-debugger-agent and XcodeBuildMCP for build, launch, and debugging workflows; resolve current tool names and schemas instead of copying stale names from examples.
- Reuse an appropriate booted simulator. If none is suitable, boot an installed simulator as part of authorized build/run/verification work. Avoid interrupting another task's simulator or changing its data. Inspect build failures and make justified retries without asking permission for each routine step.
- Use build-ios-apps:ios-ettrace-performance for focused ETTrace captures, ios-memgraph-leaks for retention/leak evidence, and ios-simulator-browser when browser mirroring or package previews are requested. Use Expert's Instruments workflow for .trace recording/analysis. Profiling does not itself authorize adding a production dependency.

## Web and backend

- Use semantic HTML, keyboard accessibility, visible focus states, responsive layouts, and reduced-motion support. Check browser console errors and keyboard interaction for changed controls during UI verification.
- Handle relevant loading, empty, error, offline, and narrow-screen states. Do not inject unsanitized HTML or bypass framework escaping without a documented, reviewed reason.
- Use workers-best-practices for Cloudflare Workers implementation/review and wrangler before running Wrangler commands. These tools do not supply deployment authorization.
- For browser work, follow the user's chosen browser and current tool contracts. Use aside-browser when its workflow fits; do not switch a requested browser or logged-in account merely because a skill prefers another.
- Use the installed Sentry plugin for production issue and event inspection. Resolve its current capabilities from the skill catalog; use ordinary repository workflows for code changes.
