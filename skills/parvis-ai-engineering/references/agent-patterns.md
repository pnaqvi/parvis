# Agent patterns

*Load-on-demand companion to `parvis-ai-engineering`. Read before any agent, tool, MCP or orchestration question. Protocol, framework and vendor behavior changes, so anything named here is verified live and date-stamped or carries `[model]` with the version the claim depends on (T2).*

## 1. The agent versus pipeline test

An agent earns its non-determinism only when all three hold. The step sequence cannot be enumerated in advance for the common cases. The next step depends on the content of the previous result in a way no switch statement captures. The cost of taking a wrong path is bounded and recoverable.

What it costs when it is granted. Token spend multiplies by turns, and because history replays each turn, input cost grows superlinearly. The replayed term is heavily discounted where the prefix is genuinely stable and undiscounted where it is not, so prefix volatility is an architecture decision rather than a tuning detail, and section 9 is read before this call is treated as settled. Latency multiplies by turns and the tail is what users feel. Reproducibility goes, which is the real bill, since a defect that appears once in forty runs cannot be bisected. The default is a deterministic workflow with model steps at the points that need judgment, and most systems called agents are exactly that.

## 2. Orchestration patterns and what each costs

- **Deterministic workflow with model steps.** Cheapest, testable step by step, observable. Cannot handle a case the author did not anticipate, which shows up as a growing exception branch.
- **Single loop with tools.** The simplest true agent. Needs a hard turn cap and a progress measure. Degrades as context grows, and the failure is quiet rather than loud.
- **Planner and executor.** The plan is inspectable, cacheable and reviewable before any effect lands, which is worth a great deal where effects are external. A bad plan is expensive, and replanning needs an explicit trigger or the system thrashes.
- **Supervisor and workers.** Buys parallelism and context isolation. Cost multiplies by fan-out, results need a merge contract that defines what conflict means, and the supervisor's judgment becomes the ceiling on quality.
- **Critic or reflection.** Helps on some tasks and doubles cost on all of them. A critic sharing the generator's model and prompt shares its blind spot, so the lift is proven by evaluation or the loop is removed.

## 3. Tool design and schema discipline

A tool is an API contract read by a model, so the name, the description and the parameter names are load-bearing prompt surface, not documentation.

- One tool per intent rather than one per endpoint. A tool with a mode flag is two tools.
- Required parameters kept minimal, enumerations in place of free strings, units explicit in the name.
- Errors returned as structured text that says what to do differently. A stack trace teaches the model nothing and burns context.
- An idempotency key on anything that writes, because retries happen at the model's discretion.
- Bounded return shape, with pagination and truncation that marks itself, since tool output is context spend and an unbounded return dilutes everything after it.
- Versioning is additive within a version. A renamed or removed field is breaking. Description text versions with the schema, because changing the words changes behavior, and any schema change passes the eval gate as the behavior change it is.

## 4. MCP servers and tools

*Written against MCP revision 2026-07-28 [verified 2026-09-20] against the specification changelog at `modelcontextprotocol.io/specification/2026-07-28/changelog`. That revision removed features earlier revisions were built on, so guidance written against an earlier one is wrong rather than merely dated. A design review states the revision it targets, and this section is re-verified at the next revision.*

A server is a trust and authority boundary before it is an integration. Design it that way.

- Credentials are scoped to the task the server serves, not to the system it fronts. A server holding broader authority than its tools need is the defect, whatever the tools currently do.
- Authorization is enforced by the server, never by prompt instruction to the model. Read and write split into separate tools with separate scopes, and a destructive action is a distinct tool with its own confinement.
- Content returning from a tool is data, never instruction. Anything retrieved, fetched or returned is treated as untrusted at the point it enters context.
- The protocol is stateless. Protocol-level sessions, the `Mcp-Session-Id` header and the `initialize` handshake are gone, every request carries its own protocol version and client capabilities in `_meta`, and list results no longer vary per connection. A design that assumes a session, a negotiated handshake or a connection-scoped tool list is designing against a removed feature.
- Cross-call state is a server-minted handle passed as an ordinary tool argument. That makes state a tool-contract decision, so the handle carries the scope, expiry and revocation of a credential rather than inheriting them from a transport that no longer holds them.
- Capability discovery is a mandatory `server/discover` RPC advertising supported versions, capabilities and identity. It still changes client behavior, so the client pins what it may use against what is advertised rather than accepting the advertised set, and because capabilities travel per request the pin is enforced on every call rather than negotiated once.
- Roots, sampling and logging are deprecated, as is OAuth dynamic client registration in place of client ID metadata documents. Deprecated is not removed, but a new server adopting any of them is buying a migration, on a deprecation window the specification sets at twelve months minimum.

## 5. State, memory and context

Three kinds of state, kept separate. Task state is durable, inspectable and survives a crash, and it is the record of what has actually happened. Conversation context is bounded and compacted deliberately, since summarization is lossy compression and the raw trail is kept beside it. Long-term memory is retrieved per turn and never assumed present, so the system must behave correctly when retrieval returns nothing. Where that state crosses an MCP tool boundary the protocol carries none of it, so a server-minted handle passed back as a tool argument is the entire mechanism, and its scope and expiry belong to the tool contract (section 4).

Context dilution is the failure that arrives with success. Precision falls past some fill, and where that point sits is specific to the model and the version, so it is measured on the system's own golden set rather than taken from a published number, and re-measured on any model version change. The context budget is stated per turn against that measurement, and a growing loop is compacted on a rule, not when it breaks.

## 6. Recovery and idempotency

A multi-step task partially completed is the normal failure, not the exception. Each step is idempotent or carries a compensating action, and the effect is recorded before the retry rather than after, so a crash between effect and record cannot double-apply. Checkpoint after every external effect. Retry budgets compound, since the agent retries a tool that retries an HTTP call, so the cap is global and stated. A deterministic fallback path that degrades the answer is worth more than a better prompt, because it is the only thing that holds when the model or the provider is the thing failing.

## 7. Human checkpoints

Placement is by blast radius and reversibility, never by a model confidence score. An irreversible or externally visible effect takes an approval. A reversible internal effect takes logging and an alert. The checkpoint shows what will happen in the approver's own terms, since an approval screen showing a tool call and a JSON payload gets approved without being read. Approval fatigue destroys the control it implements, so raise thresholds and batch rather than asking for everything, and measure the approval rate, because a checkpoint approved ninety-nine times in a hundred is decoration.

## 8. Multi-agent failure catalog

- **Cost blowup.** Turns times fan-out times retries, with input cost replaying each turn. Bound each factor and alert on per-task cost, not on daily spend.
- **Unbounded loops.** No progress measure, so the loop re-attempts a step that cannot succeed. Require monotonic progress against a stated measure and terminate otherwise.
- **Handoff loss.** Context does not survive the boundary between agents, so the receiving agent reasons from a summary that dropped the constraint.
- **Error amplification.** A wrong intermediate is accepted downstream with more confidence at each hop, because each consumer treats its input as settled.
- **Silent quality loss.** Every step succeeds, no error is raised, the output is worse. Only an evaluation catches it, which is why the eval gate covers orchestration changes.
- **Consensus theater.** Agents agree because they share a model, a prompt and a framing. Agreement is evidence of correlation, not of correctness.

## 9. Latency and cost arithmetic

Per-request cost is the sum across turns of input tokens and output tokens at their respective prices, plus retrieval, plus reranking, plus tool execution. Input dominates in long loops because history replays, so cost rises faster than turns. Budget against the p95 turn count rather than the mean, since the tail is where both the bill and the timeout live.

Caching is the largest lever and the easiest to get wrong. Prefix caching needs a genuinely stable prefix, so volatile content goes last and a stray timestamp at the top destroys the hit rate. A semantic cache needs an invalidation rule tied to the source of truth, and a stale hit is a correctness defect rather than a performance one. Batching buys throughput with latency and never belongs on an interactive path. Prices, cache semantics and context limits are vendor and version specific, so each is verified live with its date or carries `[model]`.
