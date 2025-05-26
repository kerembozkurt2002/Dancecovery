# Undercover Game Clone

A Flutter-based multiplayer party game where players must identify the Undercover player through word descriptions and voting.

## Features

- Player setup (3-12 players)
- Role distribution (Undercover vs Citizens)
- Word pair system
- Interactive voting system
- Win condition tracking

## Setup Instructions

1. Ensure you have Flutter installed on your system
   - Download Flutter SDK from https://flutter.dev/docs/get-started/install
   - Add Flutter to your system's PATH
   - Run `flutter doctor` to verify installation

2. Clone this repository
   ```bash
   git clone [repository-url]
   cd dancecovery
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Project Structure

- `lib/`
  - `models/` - Data models for players, roles, and game state
  - `screens/` - UI screens for different game stages
  - `widgets/` - Reusable UI components
  - `utils/` - Helper functions and constants
  - `main.dart` - Entry point of the application

## Game Rules

1. Players are assigned roles (Undercover or Citizen)
2. Each role receives a secret word
3. Players take turns describing their word without saying it
4. After descriptions, players vote to eliminate a suspect
5. Game continues until win condition is met:
   - Citizens win if Undercover is eliminated
   - Undercover wins if only two players remain 


## Images

![image](https://github.com/user-attachments/assets/91e870ae-aa7d-4604-9604-c3ff601ef3b9)


![image](https://github.com/user-attachments/assets/d52cf10c-cbd8-4c0a-adfa-9d3b2ed233ac)

