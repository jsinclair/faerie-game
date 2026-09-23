# Faerie Game --- Project Context

## Purpose

**Faerie Game** is the working name for a small 2D game using hand-drawn
artwork created by my 8-year-old daughter.

The project has two purposes:

1. Make a fun, deliberately imperfect game using her drawings for
characters and environments.
2. Use it as a practical learning project for Godot before starting a
larger, more serious pixel-art sidescroller/investigation game.

The hand-drawn artwork does **not** need to look polished. The roughness
and inconsistencies are part of the intended character of the game.

## Developer Context

I am an experienced software engineer, primarily with an iOS/Swift
background. I am comfortable with programming and software architecture,
so explanations do not need to teach basic programming concepts.

I have some older game-development knowledge, but have not done this
kind of game programming for a long time.

I have now:

* Updated/installed Godot.
* Completed the introductory Godot tutorials.
* Created a blank Faerie Game project.
* Put the Godot project in a subdirectory of the repository rather
than using the repository root.

The goal from here is to learn Godot by building the actual game rather
than continuing through generic tutorials.

## Technology Decisions

### Engine: Godot 4

Godot was chosen because:

* It has strong first-class 2D support.
* Its scene/node architecture works well for both games.
* It provides the engine functionality we need without requiring us to
build low-level game systems ourselves.
* Faerie Game can act as a learning project whose knowledge transfers
directly to the later serious game.

### Language: GDScript

Use **GDScript by default**.

Reasons:

* It is Godot's native scripting language and has excellent engine
integration.
* Most Godot documentation/examples use it.
* Keeping the project primarily in one language is preferable.
* The games are unlikely to contain gameplay code computationally
expensive enough to justify C# or C++.

Performance principle:

> Use GDScript unless profiling identifies a real performance problem.

If a genuinely CPU-heavy subsystem eventually requires native
performance, consider isolating that subsystem behind a C++ GDExtension
rather than moving the whole game away from GDScript.

## Repository Structure

The repository root represents the overall project; the Godot project
lives beneath it.

Conceptually:

``` text
faerie-game/
├── README.md
├── docs/
│   └── PROJECT\_CONTEXT.md
├── reference/
│   └── artwork/
├── faerie-game/
│   ├── project.godot
│   └── ...
└── .gitignore
```

This allows documentation, original artwork scans, design material, etc.
to live outside the Godot project.

This is particularly useful for high-resolution original scans: Godot
does not need to import source/reference artwork that is not intended to
ship with the game.

The generated `game/.godot/` directory should be ignored by Git.

## Godot Mental Model

An important earlier concern was that Godot initially felt overly
static/editor-driven because everything appeared to stem from a node
tree.

The mental model we settled on is:

> \*\*The scene tree is not the game. It is the collection of objects that
> currently exist.\*\*

Useful interpretations:

* **Node** --- a runtime object participating in the scene tree.
* **Scene (`.tscn`)** --- a reusable/serialized object graph or
template, not necessarily a complete game screen.
* `instantiate()` --- creates an instance of a scene.
* `add\_child()` --- inserts an object into the current runtime tree.
* `queue\_free()` --- removes/destroys an object.
* **Signals** --- event communication between objects.
* **Resources** --- reusable/serializable data objects.
* **Autoloads** --- persistent application-level objects/services that
remain alive across scene changes.

The editor should be used where visual composition is useful, while code
can control lifecycle, state, randomization, spawning, and game
behaviour.

Scenes and game objects do **not** need to be statically assembled
entirely in the editor.

## Autoloads

Autoloads can hold data and/or behaviour that needs to survive scene
changes.

For example:

``` gdscript
extends Node

var selected\_character: String
var current\_level: String
var collected\_items: Array\[String] = \[]
```

An Autoload such as `GameState` could be accessed from different scenes:

``` gdscript
GameState.selected\_character
```

Important distinction:

> Autoload persistence lasts for the running game process. It is not
> automatically persistent save data.

A save/load system would serialize relevant state to disk separately.

Avoid eventually turning `GameState` into one enormous global object;
larger projects can use it to coordinate more focused state
objects/services.

## Player Characters and Reuse

Godot scenes support inheritance.

A common player scene could contain shared structure:

``` text
Player (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── Camera2D
├── InteractionArea
└── AudioStreamPlayer2D
```

Inherited scenes can specialize that structure.

GDScript also supports normal script inheritance.

However, prefer data-driven configuration when characters differ only by
data.

For example, if characters share behaviour but differ in:

* sprite
* movement speed
* jump strength
* health
* other stats

consider one `Player.tscn` plus `CharacterData` Resources rather than
creating a subclass/inherited scene for every character.

Use inheritance or composition when characters actually differ in
structure or behaviour.

## Artwork Workflow

For Faerie Game:

1. Scan the original hand-drawn artwork at good quality.
2. Keep original scans outside the Godot project, e.g. under
`reference/artwork/`.
3. Clean obvious scanning/background noise as needed.
4. Preserve the imperfect hand-drawn edges and character.
5. Export processed game assets as transparent PNGs under the Godot
project.
6. Use those assets directly in Godot.

Do not unnecessarily redraw the artwork digitally. The handmade
appearance is part of the game's identity.

Potentially separate drawings into body components when useful for
simple cut-out-style animation.

## Later Serious Game

The second planned project is a more serious **pixel-art 2D
sidescroller/platformer with investigation mechanics**.

Likely concerns include:

* exploration/platforming
* dialogue
* evidence and clues
* NPC knowledge/state
* world/story state
* interactions
* save/load
* potentially substantial state-driven narrative logic

PyxelEdit has already been used for some mockups. Aseprite may be useful
later, especially for sprite animation, but there is no need to switch
away from PyxelEdit where it already works well.

Godot should generally own the actual runtime levels even if external
tools are used to create/mock up tiles and environments.

Faerie Game should help establish Godot conventions and architectural
preferences before tackling this larger project.

## Physics / Delta Reminder

For frame-rate-independent movement:

``` gdscript
speed += acceleration \* delta
position += velocity \* delta
```

does **not** apply `delta` incorrectly twice.

The first operation integrates acceleration into speed:

``` text
pixels / second² × seconds = pixels / second
```

The second integrates velocity into position:

``` text
pixels / second × seconds = pixels
```

`move\_toward()` is useful for expressing acceleration/deceleration
cleanly:

``` gdscript
var target\_speed := 0.0

if Input.is\_action\_pressed("ui\_up"):
    target\_speed = max\_speed

speed = move\_toward(speed, target\_speed, acceleration \* delta)
```

## Development Approach

Do not over-engineer the first version.

In particular, resist applying large-scale application architecture
before understanding how Godot naturally solves the problem.

General principle:

> Build something small, understand how Godot wants it structured, then
> refactor based on real requirements.

Faerie Game is intentionally a learning project, so discovering and
correcting imperfect early architecture is useful rather than a failure.

## Next Step

The tutorials are finished. **Do not continue with more generic
tutorials unless a specific knowledge gap requires one.**

The next milestone is a tiny playable architecture exercise:

``` text
Main Menu
    ↓
Start Game
    ↓
Game shell dynamically loads test level
    ↓
Selected player is dynamically instantiated
    ↓
Player can move/jump around
    ↓
Return to Main Menu
```

Use placeholder graphics initially. Coloured rectangles are completely
acceptable.

The purpose of this milestone is to learn:

* scene composition
* runtime scene instantiation
* dynamic level loading
* player spawning
* scene lifecycle
* input
* basic platformer movement
* returning between game/menu states

It should specifically reinforce that Godot scenes are reusable runtime
object graphs rather than static screens.

After that:

1. Add some randomized objects/enemies to the test level.
2. Become comfortable with dynamic scene contents.
3. Process the first piece of the daughter's artwork.
4. Replace the placeholder player with the first real Faerie Game
character.

At that point, continue feature-by-feature rather than designing the
entire game up front.

## Guidance for ChatGPT

When helping with this project:

* Assume solid general software-engineering knowledge.
* Explain Godot-specific concepts and game-development concepts rather
than basic programming.
* Prefer explaining *why* Godot conventions work the way they do.
* Use GDScript unless there is a concrete reason not to.
* Avoid premature abstraction/optimization.
* Encourage profiling before considering C#/C++ for performance.
* Treat Faerie Game as both a real small game and a learning vehicle
for the later serious game.
* Prefer iterative implementation and architectural discussion over
large code dumps.

