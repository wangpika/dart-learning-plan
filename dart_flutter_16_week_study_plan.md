# 16-Week Dart & Flutter Study Plan

## Goal

Build a strong mental model of Dart and Flutter so you can reason independently about unfamiliar code, choose appropriate patterns, and explain why an implementation is idiomatic.

This plan is designed for an experienced Java/JavaScript senior software engineer transitioning to Dart/Flutter. It assumes **2 hours per day**, approximately **14 hours per week**, for 16 weeks (about 224 hours, with some flexibility).

The focus is not on learning programming from scratch. It is on Dart-specific language features, Flutter's UI model, event-driven mechanics, state management, architecture, testing, and engineering judgment.

## How to study

Use a consistent two-hour session:

- **15 min — Recall:** Explain yesterday's concept or reconstruct an example without notes.
- **25 min — Focused study:** Read official documentation for one specific concept.
- **55 min — Hands-on coding:** Implement examples, test edge cases, and change requirements.
- **15 min — Compare alternatives:** Rewrite the solution and consider readability, type safety, extensibility, and complexity.
- **10 min — Learning notes:** Record one rule of thumb, one trade-off, and one unresolved question.

Suggested weekly rhythm:

| Day | Focus |
|---|---|
| Monday | Learn the core concept and write small examples |
| Tuesday | Practice syntax and focused exercises |
| Wednesday | Apply the concept to the capstone |
| Thursday | Explore edge cases, errors, and alternatives |
| Friday | Write tests and refactor |
| Saturday | Review unfamiliar code and explain the design |
| Sunday | Light review, catch-up, or rest |

Split the daily session into two one-hour blocks if that better fits parental leave. Consistency matters more than making every session feel formal.

## One evolving capstone project

Build a **Product Explorer** Flutter app with:

- Product list and search
- Product details and favorites
- Simulated API requests
- Loading, empty, success, and error states
- Retry and error handling
- Tests
- Shared state where appropriate

Evolve it through the plan:

1. **Weeks 1–3:** Model products, queries, API results, and errors using Dart's type system.
2. **Weeks 4–6:** Build screens, lists, navigation, and reusable widgets.
3. **Weeks 7–9:** Add asynchronous search, sealed UI states, events, and favorites state.
4. **Weeks 10–12:** Add services, repositories, dependency injection, and tests.
5. **Weeks 13–16:** Improve API design, concurrency, performance, and maintainability.

The app's appearance is secondary. The goal is to understand and explain its data flow, state transitions, type choices, and design trade-offs.

---

# Phase 1 — Dart fundamentals and idiomatic thinking

**Weeks 1–3 · 42 hours**

## Week 1 — Types, null safety, and control flow

### Topics
- `var`, `final`, `const`, `late`, and explicit types
- Null safety: `?`, `!`, `??`, `??=`, `?.`, nullable promotion, and flow analysis
- Type inference, subtyping, `dynamic`, `Object`, and `Object?`
- Functions, named and optional parameters, arrow functions, and closures
- `if`, loops, traditional switch statements, switch expressions, and guards

### Practice
1. Port utility functions from JavaScript or Java to Dart.
2. Implement a price calculator with optional discounts and nullable inputs.
3. Write both a switch statement and switch expression for the same problem.
4. Introduce nullability and type errors deliberately; understand analyzer messages.

### Checkpoint
Explain the differences between `String?`, `String`, `dynamic`, and `Object?`, and choose an appropriate type without trial and error.

## Week 2 — Classes, generics, and the object model

### Topics
- Constructors, named constructors, factory constructors, and initialization
- `extends`, `implements`, `with`, and `abstract`
- Getters, setters, extensions, and an introduction to extension types
- Generics, bounds, variance concepts, and constraints
- Immutable objects, equality, identity, and copying
- Class modifiers: `base`, `interface`, `final`, `sealed`, and `mixin`

### Practice
1. Design a generic repository interface.
2. Model API responses using classes rather than unstructured maps.
3. Implement a small hierarchy of payment or network-result types.
4. Compare inheritance-based design with composition and mixins.

### Checkpoint
Explain why you chose a class, interface, mixin, or composition for a particular problem.

## Week 3 — Modern Dart: records, patterns, and sealed types

### Topics
- Records and named versus positional fields
- Pattern matching and destructuring
- Type, object, list, and map patterns
- `if-case`, switch cases, switch expressions, guards (`when`), and logical patterns
- Sealed class hierarchies and exhaustive switches
- When to use patterns versus ordinary conditionals or explicit type checks

### Practice
1. Model a network response with `Loading`, `Success`, and `Failure` types.
2. Process those states using both block-bodied and expression-bodied functions.
3. Destructure a record and an object in a switch case.
4. Add a new subtype and observe which exhaustive switches need updating.
5. Refactor a nested `if`/`else` chain using patterns; compare readability.

### Checkpoint
Given an unfamiliar Dart switch, identify what it matches, which variables it introduces, whether it uses a guard, and whether it is exhaustive.

### Recommended reading
- [Dart language tour](https://dart.dev/language)
- [Patterns](https://dart.dev/language/patterns)
- [Records](https://dart.dev/language/records)
- [Class modifiers](https://dart.dev/language/class-modifiers)

---

# Phase 2 — Understand Flutter rather than memorize widgets

**Weeks 4–6 · 42 hours**

## Week 4 — Declarative UI and widget composition

### Topics
- Widget, Element, and RenderObject: what each represents
- Widget trees versus element trees
- `StatelessWidget` and `StatefulWidget`
- The `build()` method, rebuilds, identity, and immutability
- Composition versus inheritance
- `BuildContext` and its relationship to the element tree

### Practice
Build a profile page and product list. Add state changes and log which widgets rebuild. Extract components and compare the result with a large monolithic widget.

### Checkpoint
Explain why a rebuild is not necessarily a new state object or a full screen repaint.

## Week 5 — Layout, lifecycle, keys, and forms

### Topics
- Flutter layout: constraints go down, sizes go up, parents set positions
- `Row`, `Column`, `Expanded`, `Flexible`, `Stack`, and scrolling
- Lifecycle: `initState`, `didUpdateWidget`, `dispose`, and `setState`
- Local state, controllers, focus, and form validation
- Keys, including `ValueKey` and `GlobalKey`, and when they matter
- Common layout and lifecycle bugs

### Practice
Build a form with validation, a reorderable list, and a detail page. Investigate state retention when list items move or widgets change identity.

### Checkpoint
Diagnose overflow, unexpected state resets, and lifecycle errors instead of making random widget changes.

## Week 6 — Rendering, navigation, and UI behavior

### Topics
- Navigation and route arguments
- Implicit versus explicit animations
- Images, clipping, opacity, transforms, and painting
- Inherited dependencies and shared information
- Rebuilding versus relayout, repainting, and expensive compositing

### Practice
Implement a multi-screen flow, an animated loading state, and an image-overlay effect. Profile the image effect on representative hardware.

### Checkpoint
Trace a UI behavior from user action through state changes to layout and rendering.

### Recommended reading
- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter architectural foundations](https://docs.flutter.dev/app-architecture)

---

# Phase 3 — Events, asynchronous programming, and state management

**Weeks 7–9 · 42 hours**

## Core mental model

**User action or external event → event handling/business logic → state transition → reactive UI update**

Examples of events include taps, form submissions, API responses, timer ticks, and stream events. This model works with `setState`, `ValueNotifier`, `ChangeNotifier`, streams, or a more structured state-management library.

## Week 7 — Async Dart and event-driven programming

### Topics
- Event loops, synchronous execution, and asynchronous scheduling
- `Future`, `async`, `await`, error propagation, and `try`/`catch`
- `Stream`, subscriptions, transformations, and cancellation
- Microtasks versus event-queue work at a conceptual level
- Race conditions, request cancellation, stale responses, and cleanup

### Practice
Implement search-as-you-type with a simulated API. Make requests finish out of order and prevent an older response from overwriting a newer result. Add a stream-based event source and dispose its subscription correctly.

### Checkpoint
Distinguish a `Future` representing one eventual result from a `Stream` representing multiple events, and reason about errors and lifecycle.

## Week 8 — State modeling with sealed classes

### Topics
- Ephemeral state versus shared application state
- State ownership and single sources of truth
- State machines and legal versus illegal transitions
- Sealed classes, immutable state, and exhaustive rendering
- Commands, events, state transitions, and one-off UI effects
- Why unrelated booleans can produce invalid combinations

### Practice
Implement a data-loading feature with `Initial`, `Loading`, `Loaded`, and `Failure` state types. Render them with a switch expression. Add retry behavior and tests for state transitions.

Example:

```dart
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.name);
  final String name;
}

final class ProfileFailure extends ProfileState {
  ProfileFailure(this.message);
  final String message;
}
```

### Checkpoint
Know when a sealed hierarchy improves correctness and when a nullable field or boolean is enough.

## Week 9 — State-management approaches

### Topics
- `setState` and widget-local state
- `ValueNotifier` and `ChangeNotifier`
- Declarative state rendering and dependency propagation
- State ownership, testability, and coupling
- Introduction to one structured library used by your team, such as Riverpod or Bloc
- Separating user intent, state, and side effects

### Practice
Implement the same small feature with local state and one shared-state approach. Compare code volume, testability, and ease of reasoning.

### Checkpoint
Explain why a feature needs a particular state-management approach instead of choosing a library by popularity.

### Recommended reading
- [Flutter state management](https://docs.flutter.dev/data-and-backend/state-mgmt)
- [Flutter architecture](https://docs.flutter.dev/app-architecture)

**Important:** Do not spend these weeks learning five competing libraries. Learn the underlying concepts first, then become proficient in the one your team actually uses.

---

# Phase 4 — Production architecture, testing, and maintainability

**Weeks 10–12 · 42 hours**

## Week 10 — Architecture and separation of concerns

### Topics
- UI, view model or controller, repository, and service responsibilities
- Dependency inversion and dependency injection
- Interfaces, fakes, mocks, and test seams
- Domain models versus API/DTO models
- Error mapping, caching, and retry policies
- When to introduce a use case versus calling a repository directly

### Practice
Build a profile feature that loads from a fake service, converts the response into a domain model, and exposes UI-ready state.

### Checkpoint
Explain where each piece of logic belongs and what would need to change if the API were replaced.

## Week 11 — Testing as an engineering tool

### Topics
- Unit, widget, and integration tests
- Testing asynchronous behavior and error paths
- Testing sealed state transitions and exhaustive outcomes
- Fake time and deterministic tests where appropriate
- Testing interactions without overusing mocks
- Reading test failures and debugging root causes

### Practice
Test successful requests, empty results, errors, retries, rapid repeated input, and widget disposal. Write tests before refactoring one feature.

### Checkpoint
Design tests that validate behavior without tightly coupling to implementation details.

## Week 12 — Idiomatic code and maintainable APIs

### Topics
- Dart naming, API design, effective immutability, and small interfaces
- Extension methods, generics, and reusable abstractions
- Exceptions versus explicit result types
- Linting, formatting, analyzer diagnostics, and documentation
- Avoiding overengineering, unnecessary abstractions, and excessive nesting
- Refactoring duplicated logic while keeping code easy to navigate

### Practice
Refactor a capstone feature for readability and document why you chose each important abstraction.

### Checkpoint
Another engineer should be able to understand the design without needing you to explain every decision.

### Recommended reading
- [Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide)
- [Dart testing](https://dart.dev/tools/testing)
- [Flutter testing](https://docs.flutter.dev/testing/overview)

---

# Phase 5 — Advanced Dart and engineering judgment

**Weeks 13–16 · 56 hours**

## Week 13 — Advanced type modeling and language features

### Topics
- Generic constraints and variance in practical API design
- Covariant parameters and substitutability
- `typedef`, function types, callbacks, and higher-order functions
- Advanced patterns, nested destructuring, guards, and records
- Class modifiers and closed versus extensible hierarchies
- Equality, hash codes, value objects, and immutable data modeling

### Practice
Design a small typed API client and domain model. Evaluate two or three alternative designs and justify the trade-offs.

## Week 14 — Concurrency and robust async flows

### Topics
- Isolates and message passing
- CPU-bound work in isolates versus asynchronous I/O
- Cancellation strategies and lifecycle-aware async operations
- Concurrent requests, ordering, stale results, and deduplication
- Stream composition and backpressure concepts
- Resource ownership and cleanup

### Practice
Add concurrent loading of multiple data sources, handle partial failures, and prevent stale results from updating the UI. Profile a CPU-heavy task before and after moving it to an isolate.

## Week 15 — Flutter performance and rendering

### Topics
- Debug versus profile mode and performance instrumentation
- Rebuild frequency and widget subtree boundaries
- Layout, paint, compositing, clipping, and image memory
- Lists, lazy construction, image decoding, and caching
- Memory leaks from subscriptions, controllers, and retained objects
- Measuring before optimizing

### Practice
Profile an image-heavy screen or overlay. Identify a measurable bottleneck, change one thing, and compare results on representative hardware.

## Week 16 — Capstone, review, and consolidation

### Topics
- Build a complete feature from UI to data source
- Apply sealed states where they provide meaningful guarantees
- Add error handling, tests, and lifecycle cleanup
- Review architecture, API design, performance, and readability
- Perform a mock code review and explain the design without notes
- Create a personal Dart/Flutter reference guide

### Final checkpoint
Take a moderately unfamiliar feature, identify its state model and data flow, implement it idiomatically, and defend your decisions with clear reasoning.

### Recommended reading
- [Dart concurrency](https://dart.dev/language/concurrency)
- [Flutter performance](https://docs.flutter.dev/perf)

---

# How to learn unfamiliar Dart syntax

For every unfamiliar feature, answer four questions:

1. **What problem does this solve?**
2. **What does it guarantee that a simpler alternative does not?**
3. **When should I use it, and when should I avoid it?**
4. **How does it interact with other Dart or Flutter features?**

For example, with switch expressions and sealed classes:

- `sealed` restricts the family of direct subtypes, enabling exhaustive checking.
- A switch expression computes and returns a value.
- Object patterns identify the subtype and destructure its fields.
- `final value` binds a matched field to a local variable.
- Exhaustiveness checking can catch missing cases when the hierarchy changes.

Compare the result with a traditional `if`/`else` implementation. Ask whether the switch improves clarity, whether the hierarchy is genuinely closed, and whether a simpler model would be more appropriate.

## Personal Dart decision guide

Maintain a small reference file with one example, a default recommendation for your team's codebase, and the conditions that would lead you to choose another option.

| Question | Concepts to compare |
|---|---|
| How should I represent possible outcomes? | Enum, sealed class, nullable value, exception |
| How should I branch on a value? | `if`, switch statement, switch expression, pattern matching |
| How should I represent multiple return values? | Record, class |
| Where should state live? | Widget state, notifier, view model, repository |
| How should I represent asynchronous work? | `Future`, `Stream`, state machine |
| How should I reuse behavior? | Composition, inheritance, mixin, extension |
| How should I expose a value? | Field, getter, computed property, method |
| How should I handle an error? | Exception, explicit result type, UI error state |

---

# Weekly mastery tracker

At the end of each week, score each item from 0 to 2:

- **0:** I don't understand it yet.
- **1:** I can use it with documentation or examples.
- **2:** I can explain it, implement it from scratch, and recognize when it is appropriate.

| Criterion | Score (0–2) |
|---|---:|
| Explain the concept without notes | |
| Implement a working example from scratch | |
| Explain an alternative and its trade-off | |
| Test an edge case or failure scenario | |
| Recognize the pattern in unfamiliar code | |
| **Total** | **/10** |

Aim for 8 or higher. If you score lower, revisit the weakest concepts rather than restarting the entire week.

---

# Week 1, Day 1 — Getting started

**Topic:** Dart variables, type inference, and mutability  
**Time:** 2 hours

## Objectives
- Explain `var`, `final`, and `const`.
- Understand how Dart infers and enforces types.
- Distinguish an immutable variable from an immutable object.
- Choose an appropriate declaration for common application code.

## Step 1 — Set up your environment (10 min)

If Dart and Flutter are already installed, use your existing setup. Otherwise, start with [DartPad](https://dartpad.dev/), which runs Dart in the browser.

## Step 2 — Study the concept (25 min)

Read the [Dart variables guide](https://dart.dev/language/variables).

```dart
var name = 'Alex';
final city = 'Malvern';
const maxRetries = 3;
String? nickname;
```

- `var`: Dart infers a static type from the initializer. It does not mean the variable can hold any type.
- `final`: The variable can be assigned only once.
- `const`: The value is a compile-time constant.
- `String?`: A string variable that can contain `null`.

`final` does not automatically make the referenced object immutable:

```dart
final names = <String>['Alice', 'Bob'];

names.add('Charlie'); // Valid
// names = ['David']; // Compile-time error
```

The variable cannot be reassigned, but the list it references can be modified.

## Step 3 — Exercises (55 min)

Predict the behavior, then verify it in DartPad.

1. What is the inferred type of `x`?

   ```dart
   var x = 10;
   x = 20;
   // x = 'hello';
   ```

2. Which statement about `final` is correct?

   ```dart
   final items = <int>[1, 2, 3];
   ```

   Can the list change? Can the variable be reassigned?

3. Which declaration requires a compile-time constant initializer: `var`, `final`, `const`, or `String?`?

4. What is the static type of `value`?

   ```dart
   Object value = 'hello';
   ```

5. Which type permits null: `String`, `String!`, `String?`, or `final String`?

Then write a short Dart program that declares a product name, price, and optional discount. Calculate the final price, and deliberately try invalid assignments to see which errors Dart catches.

## Step 4 — Explain your reasoning (15 min)

Answer in your own words:

1. Why does `var x = 10` not allow you to later assign `'hello'` to `x`?
2. What's the difference between `final` and `const`? When would you use each?
3. Why can you call `add()` on a `final List`, but not assign a different list to the same variable?
4. What advantage does Dart's static type inference offer over declaring everything `dynamic`?

## Step 5 — Review (15 min)

Write down any syntax that feels unfamiliar, especially anything you instinctively expected to behave like Java or JavaScript.

**Next action:** Complete the exercises and send your answers to the four reasoning questions, along with your product-price program. Ask ChatGPT to review correctness, idiomatic Dart, readability, and trade-offs.

Use the review to decide whether to move on to Day 2 or reinforce today's concepts.

---

# Primary resources

1. [Dart language tour](https://dart.dev/language)
2. [Effective Dart](https://dart.dev/effective-dart)
3. [Flutter documentation](https://docs.flutter.dev/)
4. [Flutter architectural foundations](https://docs.flutter.dev/app-architecture)
5. [Flutter state management](https://docs.flutter.dev/data-and-backend/state-mgmt)
6. [Dart testing](https://dart.dev/tools/testing)
7. [Flutter testing](https://docs.flutter.dev/testing/overview)
8. [Dart concurrency](https://dart.dev/language/concurrency)
9. [Flutter performance](https://docs.flutter.dev/perf)

## Final recommendations

- Spend extra time on modern Dart features: type system, null safety, generics, sealed hierarchies, and patterns.
- Learn state management through events, transitions, state ownership, and rendering before learning a library's APIs.
- Practice explaining your design decisions, not just producing code that compiles.
- Make your team's codebase part of the curriculum: record unfamiliar patterns, identify the underlying concept, reproduce it in a small example, and return to the original code.
- Don't aim to memorize every Flutter API. Aim to recognize problem categories, find authoritative answers, and make sound engineering decisions.
