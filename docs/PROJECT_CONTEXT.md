# Faerie Game — Project Context

## Purpose

**Faerie Game** is the working name for a small 2D game using hand-drawn artwork created by my daughter, Hannah.

The project has two purposes:

1. Make a fun, deliberately imperfect game using her drawings for characters and environments.
2. Use it as a practical learning project for Godot before starting a larger, more serious pixel-art sidescroller/investigation game.

The hand-drawn artwork does **not** need to look polished. The roughness and inconsistencies are part of the intended character of the game.

The project should remain fun to work on. Goals and checklists exist to provide direction and visible progress, not to turn the project into a rigid development schedule.

---

## Developer Context

I am an experienced software engineer, primarily with an iOS/Swift background. I am comfortable with programming and software architecture, so explanations do not need to teach basic programming concepts.

I have some older game-development knowledge, but had not done this kind of game programming for a long time before starting Faerie Game.

The introductory Godot tutorials are complete.

The goal is now to learn Godot by building the actual game rather than continuing through generic tutorials.

When useful, Godot concepts can be related to Swift, UIKit or SwiftUI concepts, but Godot's own conventions should take precedence rather than trying to force application-development architecture onto the game.

---

## Technology Decisions

### Engine: Godot 4

Godot was chosen because:

- It has strong first-class 2D support.
- Its scene/node architecture works well for both planned games.
- It provides the engine functionality needed without requiring low-level game systems to be built from scratch.
- Faerie Game can act as a learning project whose knowledge transfers directly to the later serious game.

### Language: GDScript

Use **GDScript by default**.

Reasons:

- It is Godot's native scripting language and has excellent engine integration.
- Most Godot documentation/examples use it.
- Keeping the project primarily in one language is preferable.
- The games are unlikely to contain gameplay code computationally expensive enough to justify C# or C++.

Performance principle:

> Use GDScript unless profiling identifies a real performance problem.

If a genuinely CPU-heavy subsystem eventually requires native performance, consider isolating that subsystem behind a C++ GDExtension rather than moving the whole game away from GDScript.

---

## Repository Structure

The repository root represents the overall project; the Godot project lives beneath it.

Conceptually:

```text
faerie-game/
├── README.md
├── docs/
│   └── PROJECT_CONTEXT.md
├── reference/
│   └── artwork/
├── faerie-game/
│   ├── project.godot
│   └── ...
└── .gitignore
```

This allows documentation, original artwork scans, design material, etc. to live outside the Godot project.

This is particularly useful for high-resolution original scans: Godot does not need to import source/reference artwork that is not intended to ship with the game.

The generated `.godot/` directory should be ignored by Git.

---

## Godot Mental Model

An important earlier concern was that Godot initially felt overly static/editor-driven because everything appeared to stem from a node tree.

The mental model that resolved this is:

> **The scene tree is not the game. It is the collection of objects that currently exist.**

Useful interpretations:

- **Node** — a runtime object participating in the scene tree.
- **Scene (`.tscn`)** — a reusable/serialized object graph or template, not necessarily a complete game screen.
- `instantiate()` — creates an instance of a scene.
- `add_child()` — inserts an object into the current runtime tree.
- `queue_free()` — removes/destroys an object.
- **Signals** — event communication between objects.
- **Resources** — reusable/serializable data objects.
- **Autoloads** — persistent application-level objects/services that remain alive across scene changes.

The editor should be used where visual composition is useful, while code can control lifecycle, state, randomization, spawning and game behaviour.

Scenes and game objects do **not** need to be statically assembled entirely in the editor.

---

## Autoloads and Game State

Autoloads can hold data and/or behaviour that needs to survive scene changes.

The project currently uses shared character data/state for information such as the selected player character and character-specific visual information.

Conceptually, an Autoload behaves more like a persistent singleton instance than a static class.

Important distinction:

> Autoload persistence lasts for the running game process. It is not automatically persistent save data.

A save/load system must serialize relevant state to disk separately.

Avoid eventually turning a single game-state Autoload into one enormous global object. Introduce more focused state objects/services only when concrete requirements justify them.

---

## Player Characters and Reuse

Player characters share common behaviour but may differ structurally.

The current direction is a common base player scene/script containing shared player behaviour, with inherited character scenes providing character-specific visuals, collision shapes and other structural differences.

Conceptually:

```text
Player (CharacterBody2D)
└── Camera2D
```

Inherited character scenes can then provide their own structure:

```text
Character
├── Camera2D (inherited)
├── Sprite2D or AnimatedSprite2D
└── CollisionShape2D
```

The base player should represent:

> Something controlled by the player.

It should not represent one particular faerie that other characters modify.

Prefer data-driven configuration when characters differ only by data. Use scene/script inheritance or composition when characters genuinely differ in structure or behaviour.

The world should not need to know whether a selected character uses a static sprite, animated sprite, different collision shape, etc.

---

## Artwork Workflow

For Faerie Game:

1. Scan original hand-drawn artwork at good quality.
2. Keep original scans outside the Godot project, e.g. under `reference/artwork/`.
3. Clean obvious scanning/background noise as needed.
4. Preserve the imperfect hand-drawn edges and character.
5. Remove the paper background where appropriate.
6. Export processed game assets as transparent PNGs under the Godot project.
7. Use those assets directly in Godot.

Do not unnecessarily redraw the artwork digitally. The handmade appearance is part of the game's identity.

### Ongoing Art Experiment: GIMP Unified Transform

Experiment with **GIMP's Unified Transform** tool to create simple sprite/animation sets from scanned drawings.

Possible techniques include:

- moving parts of the original drawing
- small rotations
- small changes in scale
- repositioning wings, limbs or other elements
- creating a few subtly different frames rather than fully redrawing a character

This is an **ongoing workflow experiment**, not a milestone that needs to be completed.

Use it when new scans or animation ideas make it useful.

---

# Current State

## Phase 1 — Playable Prototype

**Status: Complete.**

The original milestone was:

```text
Main Menu
    ↓
Start Game
    ↓
Load test world
    ↓
Instantiate selected player
    ↓
Move around
    ↓
Return to menu
```

That milestone has been exceeded.

The project now includes experience with:

- [x] Main menu and scene switching
- [x] Runtime scene instantiation
- [x] Character selection
- [x] Shared game/character state using Autoloads
- [x] Base player behaviour
- [x] Multiple player character scenes
- [x] CharacterBody2D movement
- [x] Acceleration/deceleration
- [x] Jumping and floor detection
- [x] Camera following and camera limits
- [x] Static hand-drawn character artwork
- [x] AnimatedSprite2D character artwork
- [x] Scanning and processing original artwork
- [x] Procedural terrain generation
- [x] Random terrain slopes
- [x] Random gaps
- [x] Basic procedural decorations
- [x] Randomly spawned ambient objects/wisps
- [x] Random colours
- [x] Continuous animation using `_process()`
- [x] Tween-based fading
- [x] Basic understanding of visibility versus alpha/modulation

The initial placeholder player — Rectangle Hero™ — has been retired with honours.

---

# Phase 2 — From Prototype to Tiny Game

## North Star

Turn the current collection of experiments into the beginnings of a complete playable game loop.

The target is:

```text
Character Select
       ↓
Enter Generated Level
       ↓
Traverse / Explore
       ↓
Encounter Hazards
      ↙   ↘
 Failure   Reach Goal
    ↓          ↓
  Retry      Success
```

Phase 2 does **not** need to define what the final game will ultimately be.

The goal is to build enough of a functioning game that later gameplay and design decisions can be made based on something real.

The order below represents rough dependencies, not a strict schedule.

It is fine to jump between tasks when another area seems more interesting or motivating.

---

## 1. Expand and Refactor Procedural Terrain

The current procedural generator has proven the basic concept. The next goal is to give terrain more responsibility and introduce enough variation to expose the architecture actually needed.

### Terrain Types

- [x] Add a second terrain type.
- [x] Give it meaningfully different dimensions/properties from the existing terrain.
- [x] Add at least one additional terrain type if useful for testing.
- [x] Update generation so different terrain types can be mixed.

Do **not** decide the complete terrain architecture before doing this.

Let the second/third concrete terrain types reveal what they genuinely have in common.

### Terrain Data and Architecture

- [x] Move terrain-specific properties such as width out of `World`.
- [ ] Decide how terrain exposes the information the generator needs.
- [ ] Decide whether a shared Terrain script/base scene is justified.
- [x] Remove assumptions in `World` that depend on every terrain section having the same dimensions.

Possible approaches include:

- common script/base class
- inherited terrain scene
- common exported properties
- another simple shared interface/convention

Choose based on the concrete terrain implementations rather than abstract architecture.

### Terrain Decoration

- [ ] Add more terrain decoration types.
- [x] Move decoration responsibility out of `World`.
- [ ] Allow each terrain section to decide how/where it can decorate itself.
- [ ] Test procedural generation with multiple terrain and decoration types.

Guiding principle:

> **World decides where terrain exists. Terrain decides what it is and what belongs on it.**

The generator should handle macro-level structure.

Terrain should handle local details.

---

## 2. Add More Ambient Life

Add a small amount of additional life to the generated world.

- [x] Add another simple critter.
- [ ] Add a second critter if useful/fun.
- [x] Give at least one critter some simple autonomous behaviour.

Possible behaviours include:

- wandering
- hopping
- flying
- changing direction
- reacting when the player approaches

Avoid sophisticated AI at this stage.

Not every creature needs to be an enemy or gameplay obstacle.

The whimsical world should contain things that simply live in it.

---

## 3. Health and Damage

Introduce the minimum systems required for the player to be able to fail.

### Player Health

- [ ] Add a basic player health system.
- [ ] Define maximum/current health.
- [ ] Add a `take_damage()` mechanism.
- [ ] Add simple temporary feedback when damage is taken if needed.

Keep the first implementation simple.

Do not design a large statistics/combat framework.

### First Hazard

- [ ] Add one simple environmental hazard.
- [ ] Detect player interaction/collision with the hazard.
- [ ] Apply damage through the player's health system.
- [ ] Confirm repeated damage behaves sensibly.

Prefer a stationary/simple hazard **before** building a hostile creature.

This isolates learning:

```text
collision
    ↓
damage
    ↓
health
    ↓
failure
```

from the separate problem of enemy AI.

If necessary, introduce temporary post-damage invulnerability only after testing shows that repeated collision damage requires it.

---

## 4. Failure and Retry

Once health can reach zero:

- [ ] Detect player failure.
- [ ] End or pause the current attempt.
- [ ] Provide a simple retry mechanism.
- [ ] Confirm restarting produces a clean playable level.

The first implementation can simply reload/reset the level.

### Future Presentation: Faerie Queen Rescue

The intended tone is whimsical and non-violent.

Characters should not conventionally "die" when health reaches zero.

A future narrative/presentation idea is:

> When a faerie becomes too badly hurt or overwhelmed, a Faerie Queen or similar protective figure magically teleports them to safety.

This can eventually replace a conventional death/game-over presentation.

It is **not required for the initial Phase 2 failure system**.

Mechanics first:

```text
health <= 0
    ↓
attempt failed
    ↓
retry
```

Presentation/story can be layered over that later.

---

## 5. Level Objective and Success

The game needs a way to win as well as a way to lose.

Start with the simplest useful objective:

> **Reach the end of the generated level.**

- [ ] Create a simple level-end goal/trigger.
- [ ] Ensure procedural generation leaves a valid end area.
- [ ] Detect when the player reaches the goal.
- [ ] Present simple success/completion feedback.
- [ ] Provide a way to continue or return to the menu.

The goal can later become something more thematic, such as:

- reaching a magical portal
- finding an object
- collecting something
- rescuing a creature
- completing another objective before exiting

None of that needs to be decided yet.

The important Phase 2 milestone is simply:

```text
Start Level
    ↓
Play
    ↓
Reach Goal
    ↓
Success
```

Combined with failure/retry, this creates the first complete gameplay loop.

---

## 6. Basic Save / Persistence

Saving progress was not covered by the introductory tutorials, so this is a deliberate Godot learning goal.

Do **not** begin by designing a comprehensive save-game system.

Start by persisting a tiny amount of meaningful data.

For example:

- selected character
- whether a test level has been completed

Tasks:

- [ ] Learn where Godot stores user/save data.
- [ ] Save a small piece of game state to disk.
- [ ] Load that state again.
- [ ] Close and restart the game and verify that the data survives.
- [ ] Connect persistence to at least one real piece of game progress.

Only after completing this simple round trip should the architecture of a larger save system be considered.

Important distinction:

> **Autoload = state that survives scene changes.**  
> **Save data = state that survives closing the game.**

---

## 7. Basic Dialogue System

Build a small reusable dialogue overlay.

This is **not** intended to be a branching RPG conversation system.

Initial requirements:

- [ ] Display a dialogue overlay above the game.
- [ ] Display a character portrait.
- [ ] Display the speaker's name if useful.
- [ ] Display dialogue text.
- [ ] Reveal text progressively, character by character.
- [ ] Allow input to complete/advance the current line.
- [ ] Support multiple consecutive lines.
- [ ] Cleanly close the dialogue and return control to gameplay.

Conceptually:

```text
┌──────────────────────────────────────────┐
│                                          │
│                GAME WORLD                │
│                                          │
│                                          │
├──────────┬───────────────────────────────┤
│ Portrait │ Character Name                │
│          │                               │
│          │ Dialogue appears here...      │
└──────────┴───────────────────────────────┘
```

This should provide practical experience with:

- `Control` nodes
- `CanvasLayer`
- game-space versus screen-space UI
- input while UI is active
- text presentation
- simple dialogue data
- potentially timers or tweens

Future uses include:

- introductions
- tutorials
- story moments
- NPC conversations
- eventual Faerie Queen rescue scenes

Do not implement dialogue choices or branching unless the game eventually demonstrates a real need for them.

---

# Phase 2 Completion

Phase 2 should be considered successful when the project can roughly do this:

```text
Choose Character
       ↓
Generate Level
       ↓
Spawn Player
       ↓
Traverse World
       ↓
Interact With Hazards / World
       ↓
   ┌───┴────┐
   ↓        ↓
Failure   Reach Goal
   ↓        ↓
 Retry    Success
```

Not every experimental feature above necessarily needs to be perfect before moving forward.

The important transition is:

> **Faerie Game has gone from a collection of Godot experiments to a tiny but complete game loop.**

At that point, Phase 3 can focus more directly on the larger design question:

> **What does the player actually do in Faerie Game?**

There is no need to answer that completely yet.

Build enough of the game to discover the answer.

---

# Ongoing Experiments and Ideas

These are deliberately **not milestone checkboxes**.

They should not create a feeling that the project is incomplete simply because they remain open-ended.

## Artwork / Animation

- Continue experimenting with scanned artwork.
- Remember **GIMP Unified Transform**.
- Try simple multi-frame animation from existing drawings.
- Preserve the character of Hannah's original artwork rather than pursuing technical polish for its own sake.

## World Feel

Continue experimenting with:

- ambient critters
- wisps
- decorations
- movement
- colour
- procedural variation
- small visual effects

Not everything needs a gameplay purpose.

## Whimsical / Non-Violent Tone

Avoid defaulting to conventional videogame violence simply because familiar game mechanics use it.

Hazards, failure and enemies can exist while maintaining a whimsical tone.

The Faerie Queen rescue concept is one possible example of making conventional game mechanics fit the fiction rather than allowing the mechanics to dictate the fiction.

---

## Physics / Delta Reminder

For `CharacterBody2D`, movement/collision logic belongs primarily in `_physics_process(delta)`.

Acceleration/deceleration can use `delta` when changing velocity:

```gdscript
velocity.x = move_toward(
    velocity.x,
    target_speed,
    acceleration * delta
)
```

`move_and_slide()` then uses the body's velocity to perform physics movement.

The useful dimensional mental model remains:

```text
acceleration × seconds = change in velocity
velocity × seconds = change in position
```

Using `delta` to change velocity does **not** mean it has incorrectly been applied twice when the physics system subsequently moves the body.

---

## Development Approach

Do not over-engineer the project.

In particular, resist applying large-scale application architecture before understanding how Godot naturally solves the problem.

General principle:

> **Build something small, understand how Godot wants it structured, then refactor based on real requirements.**

Prefer:

```text
Need appears
    ↓
Build simplest useful version
    ↓
Use it
    ↓
Discover actual limitations
    ↓
Refactor
```

over:

```text
Predict every future requirement
    ↓
Build abstraction hierarchy
    ↓
Eventually discover the game wanted something else
```

Faerie Game is intentionally a learning project, so discovering and correcting imperfect early architecture is useful rather than a failure.

### Motivation / Scope Principle

The roadmap exists to make progress visible and prevent the project from becoming an overwhelming collection of possible things to do.

It is **not a contract**.

If a different task sounds more fun on a particular day, work on that.

If an experiment turns out not to belong in the game, learning that is still progress.

Keep individual goals small enough that they can actually be completed and checked off.

The project should remain enjoyable.

---

## Later Serious Game

The second planned project is a more serious **pixel-art 2D sidescroller/platformer with investigation mechanics**.

Likely concerns include:

- exploration/platforming
- dialogue
- evidence and clues
- NPC knowledge/state
- world/story state
- interactions
- save/load
- potentially substantial state-driven narrative logic

PyxelEdit has already been used for some mockups. Aseprite may be useful later, especially for sprite animation, but there is no need to switch tools where the current workflow already works well.

Godot should generally own the actual runtime levels even if external tools are used to create/mock up tiles and environments.

Faerie Game should help establish Godot conventions and architectural preferences before tackling this larger project.

---

## Guidance for ChatGPT

When helping with this project:

- Assume solid general software-engineering knowledge.
- Explain Godot-specific concepts and game-development concepts rather than basic programming.
- Prefer explaining **why** Godot conventions work the way they do.
- Swift/UIKit/SwiftUI analogies are useful when they genuinely clarify a Godot concept.
- Use GDScript unless there is a concrete reason not to.
- Avoid premature abstraction and optimization.
- Prefer adding a concrete second/third example before designing a general abstraction.
- Encourage profiling before considering C#/C++ for performance.
- Treat Faerie Game as both a real small game and a learning vehicle for the later serious game.
- Prefer iterative implementation and architectural discussion over large code dumps.
- Distinguish between:
  - what is good enough now
  - what may need changing later
  - what is merely a future idea
- Do not turn exploratory ideas into requirements prematurely.
- Keep roadmap tasks approachable and concrete.
- Preserve the whimsical, hand-drawn identity of the project.
- Above all, help keep the project enjoyable and moving forward.