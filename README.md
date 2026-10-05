# Faerie Game

**Faerie Game** is a small 2D platformer being developed in Godot using hand-drawn artwork created by my daughter, Hannah.

The artwork is drawn on paper, scanned, cleaned up where necessary, and used directly in the game. The rough edges and inconsistencies are intentional — preserving the character of the original drawings is part of the point.

The project is also my practical introduction to modern game development with Godot. Rather than trying to design the entire game up front, I am building it incrementally, learning Godot concepts as the game needs them.

## Technology

- **Engine:** Godot 4
- **Language:** GDScript
- **Artwork:** Hand-drawn, scanned and processed primarily with GIMP

## Current State

The initial playable prototype is complete.

The game currently includes:

- A main menu and basic game flow.
- Character selection.
- Dynamically instantiated player characters.
- Shared player movement with character-specific scenes and artwork.
- Camera movement and level boundaries.
- Static and animated hand-drawn character sprites.
- Procedurally generated multi-level terrain.
- Random terrain gaps, slopes and decorations.
- Ambient wisps with randomized colours, movement and fading behaviour.

Development is now moving from isolated experiments toward a **small complete gameplay loop**.

The current goal is to reach the point where a player can:

> Select a character → enter a generated level → traverse the level → encounter hazards → either complete the level or fail and retry.

Beyond that, the direction of the game will continue to emerge through experimentation rather than being completely designed in advance.

## Development Philosophy

Faerie Game is deliberately a learning project.

The aim is to build something fun with Hannah's artwork while learning how Godot naturally approaches scenes, game state, procedural generation, UI, persistence, animation and gameplay systems.

Early implementations are allowed to be imperfect.

> Build something small, understand how Godot wants it structured, then refactor based on real requirements.

And, in memory of the original prototype player:

**Rectangle Hero™ — gone, but not forgotten.**