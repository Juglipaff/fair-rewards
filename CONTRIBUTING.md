# Contributing

Thanks for your interest. This is a small library repo — contributions are welcome.

## Scope

The library provides:

- The core primitive: a constant-gas, stake-age-weighted, front-run-resistant reward distribution abstract contract.
- Standards-conformant wrappers around it (e.g. ERC-4626) that expose the primitive under widely-adopted interfaces.

Changes that fit this scope are welcome:

- Bug fixes with an accompanying test that fails without the fix.
- Gas optimizations backed by `forge snapshot` before/after numbers.
- Documentation clarifications.
- Additional test cases covering under-tested paths (fuzz seeds, invariants).
- New standard-conformant wrappers (ERC-4626, ERC-20 staking wrappers, etc.) that expose the existing primitive without altering its semantics.

Out of scope:

- Alternative reward-distribution algorithms (open a discussion first — likely a separate repo).
- Application-level integrations, protocol-specific wrappers, or example dApps (belong downstream in the consumer's repo).

## Development setup

```bash
git clone https://github.com/Juglipaff/fair-reward-distributor.git
cd fair-reward-distributor
forge test
```

Foundry pulls Solidity dependencies as git submodules under `lib/` on first build. Node tooling (formatter) is optional:

```bash
pnpm install
pnpm exec prettier --check "src/**/*.sol" "test/**/*.sol"
```

## Style

Match the pattern established in `src/FairRewardDistributor.sol`. `forge fmt` + `prettier-plugin-solidity` both must pass in CI.

### Imports

Named imports only. Never bare imports.

```solidity
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";
```

Multi-name imports use the multi-line form:

```solidity
import {
    ISpotMarketPipelineHook,
    IOBookMarketPipelineHook
} from "../interfaces/ISpotMarketPipelineHook.sol";
```

### Declaration order

1. Types (structs, enums)
2. Storage (state variables + constants)
3. Events
4. Errors
5. Modifiers
6. Constructor
7. External write → view → pure
8. Public write → view → pure
9. Internal write → view → pure
10. Private write → view → pure

**Assign functions to the correct mutability bucket.** State-modifying functions belong in `write` even when they `override` an abstract hook. `pure` helpers live in `pure`, not `view`.

### Section headers

Contracts are subdivided by section headers with exactly 12 `=` on each side. One blank line before, one blank line after. Omit sections that have no members. Never mix visibility/mutability categories in the same section.

```solidity
// ============ Types ============
// ============ Storage ============
// ============ Events ============
// ============ Errors ============
// ============ Modifiers ============
// ============ Constructor ============
// ============ External Write Functions ============
// ============ External View Functions ============
// ============ External Pure Functions ============
// ============ Public Write Functions ============
// ============ Public View Functions ============
// ============ Public Pure Functions ============
// ============ Internal Write Functions ============
// ============ Internal View Functions ============
// ============ Internal Pure Functions ============
// ============ Private Write Functions ============
// ============ Private View Functions ============
// ============ Private Pure Functions ============
```

### NatSpec

`/** */` block style is the ONLY correct pattern for contracts, structs, events, errors, constructors, modifiers, and every function. Never use `///` for these.

```solidity
/**
 * @title ContractName
 * @dev One-sentence description.
 */
```

```solidity
/**
 * @dev Description of what this does.
 * @param paramName Description.
 * @return Description.
 */
```

Rules:

- Contract / interface: `@title` + `@dev`.
- Every function / event / error / constructor / modifier: `@dev` description.
- **`@param` REQUIRED for every parameter** — except when using `@inheritdoc`.
- **`@return` REQUIRED for every return value** — except when using `@inheritdoc`.
- Every declaration commented — types, storage, events, errors, modifiers, constructors, functions.
- Inherited functions use `/** @inheritdoc InterfaceName */` (single-line block) — this replaces `@dev` / `@param` / `@return`.

### State variables

Every state variable and constant gets a `///@dev` comment on the line above (no space after `///`):

```solidity
///@dev Fixed-point multiplier (1e18).
uint256 private constant UNIT = 1 ether;

///@dev Mapping from controller to pending deposit data.
mapping(address => DepositData) private _depositData;
```

`///` inline comments are ONLY acceptable for state variables. Everything else uses block comments.

### Structs

Block comment BEFORE the struct with `@dev` describing the struct and `@param` for each field. Fields inside the struct body have NO inline comments:

```solidity
/**
 * @dev Holds pending and claimable state for a deposit request.
 * @param pendingAssets Assets awaiting manager fulfillment.
 * @param claimableAssets Assets fulfilled and ready to claim.
 * @param claimableShares Shares allocated by the manager for the claimable assets.
 */
struct DepositData {
    uint256 pendingAssets;
    uint256 claimableAssets;
    uint256 claimableShares;
}
```

### Naming

- `_name` — private and internal state variables and functions.
- `name_` — constructor / function parameters that would collide with a state variable (e.g. `asset_` when `asset` is already declared).

### Misc

- Do NOT redeclare events in an implementing contract if they are already declared in an inherited interface.
- Constants use `SCREAMING_SNAKE_CASE`.

## Testing

Every behavioral change needs test coverage. This repo requires 100% branch coverage.

```bash
forge test               # unit + fuzz
forge coverage           # coverage report
forge snapshot           # gas snapshot
```

New tests should be property-based / fuzz where the invariant is universal (conservation of reward, monotonicity of `stakeAge`, etc.). Reserve unit tests for specific edge cases and error paths.

## Commits

- One logical change per commit.
- Conventional-commit prefixes: `feat:`, `fix:`, `docs:`, `test:`, `chore:`, `refactor:`.
- Subject in imperative mood, ≤ 72 chars.
- Body explains **why**, not what — the diff shows what.

## Pull requests

- Open against `main`.
- Fill in the PR template.
- Squash-merge is the only allowed merge method. Keep the PR title clean — it becomes the merged commit subject.

## Security

Do **not** file security-relevant issues in the public tracker. Report privately via one of:

- GitHub [private vulnerability reporting](https://github.com/Juglipaff/fair-reward-distributor/security/advisories/new).
- Email: juglipaff@gmail.com.

This repo has not been audited; treat vulnerabilities accordingly.

## License

By contributing, you agree that your contributions will be licensed under the MIT License (see [LICENSE](./LICENSE)).
