class Exercise {
  final String title;
  final String duration;
  final String level;
  final String instructions;
  final String imageUrl;

  Exercise({
    required this.title,
    required this.duration,
    required this.level,
    this.instructions = '',
    this.imageUrl = '',
  });

  /// Returns a list of mock exercises for "Popular Exercises"
  static List<Exercise> popularExercises() {
    return [
      Exercise(
        title: "Full Body Yoga",
        duration: "20 min",
        level: "Beginner",
        instructions:
            "1. Start in Mountain Pose (Tadasana) for 30 seconds.\n"
            "2. Flow through Sun Salutations (Surya Namaskar) for 3 rounds.\n"
            "3. Hold Warrior I (Virabhadrasana I) for 30 seconds each side.\n"
            "4. Transition to Warrior II for 30 seconds each side.\n"
            "5. End with Child's Pose (Balasana) for 1 minute.\n"
            "6. Finish with Savasana (Corpse Pose) for 2 minutes.",
        imageUrl: "assets/yoga.png",
      ),
      Exercise(
        title: "Core Strength",
        duration: "15 min",
        level: "Intermediate",
        instructions:
            "1. Plank hold for 45 seconds.\n"
            "2. 15 Russian twists (each side).\n"
            "3. 12 Bicycle crunches (each side).\n"
            "4. 10 Leg raises.\n"
            "5. 30-second Side plank (each side).\n"
            "6. 15 Mountain climbers (each side).\n"
            "Repeat the circuit 2 times.",
        imageUrl: "assets/core.png",
      ),
      Exercise(
        title: "Morning Stretch",
        duration: "10 min",
        level: "Beginner",
        instructions:
            "1. Neck rolls: 5 slow rotations each direction.\n"
            "2. Shoulder shrugs: 10 reps lifting and dropping shoulders.\n"
            "3. Arm circles: 10 forward, 10 backward.\n"
            "4. Torso twists: 10 each side.\n"
            "5. Forward fold: hold for 30 seconds.\n"
            "6. Cat-Cow stretch: 10 slow cycles.\n"
            "7. Standing quad stretch: 20 seconds each leg.",
        imageUrl: "assets/stretch.png",
      ),
      Exercise(
        title: "HIIT Cardio",
        duration: "25 min",
        level: "Advanced",
        instructions:
            "1. Jumping jacks: 45 seconds work, 15 seconds rest.\n"
            "2. High knees: 45 seconds work, 15 seconds rest.\n"
            "3. Burpees: 45 seconds work, 15 seconds rest.\n"
            "4. Mountain climbers: 45 seconds work, 15 seconds rest.\n"
            "5. Squat jumps: 45 seconds work, 15 seconds rest.\n"
            "Repeat the circuit 3 times.\n"
            "Cool down with 2 minutes of light stretching.",
        imageUrl: "assets/hiit.png",
      ),
      Exercise(
        title: "Pilates Flow",
        duration: "30 min",
        level: "Intermediate",
        instructions:
            "1. The Hundred: pump arms 100 times while holding a crunch.\n"
            "2. Roll Up: 8 slow, controlled reps.\n"
            "3. Single Leg Circles: 5 circles each direction per leg.\n"
            "4. Rolling Like a Ball: 10 reps.\n"
            "5. Single Leg Stretch: 10 reps each leg.\n"
            "6. Double Leg Stretch: 10 reps.\n"
            "7. Spine Stretch Forward: hold for 20 seconds.\n"
            "8. Saw: 5 reps each side.",
        imageUrl: "assets/pilates.png",
      ),
      Exercise(
        title: "Power Walking",
        duration: "45 min",
        level: "Beginner",
        instructions:
            "1. Warm-up: 5 minutes at a comfortable pace.\n"
            "2. Increase speed to a brisk walk for 30 minutes.\n"
            "3. Maintain good posture: head up, shoulders back.\n"
            "4. Swing arms naturally with each step.\n"
            "5. Cool down: 5 minutes at a slow pace.\n"
            "6. Finish with 5 minutes of calf and hamstring stretches.",
        imageUrl: "assets/walking.png",
      ),
      Exercise(
        title: "Dance Fitness",
        duration: "30 min",
        level: "Beginner",
        instructions:
            "1. Warm-up: 3 minutes of basic steps.\n"
            "2. Learn the main choreography (4 sets of 8 counts).\n"
            "3. Practice each set slowly for 2 minutes.\n"
            "4. Combine sets and increase speed.\n"
            "5. Full routine: 10 minutes of non-stop dancing.\n"
            "6. Cool down: 5 minutes of stretching.\n"
            "Repeat steps 2-5 for a second round.",
        imageUrl: "assets/dance.png",
      ),
      Exercise(
        title: "Strength Training",
        duration: "40 min",
        level: "Advanced",
        instructions:
            "1. Squats: 3 sets of 12 reps.\n"
            "2. Push-ups: 3 sets of 10 reps.\n"
            "3. Bent-over rows: 3 sets of 12 reps (use dumbbells if available).\n"
            "4. Overhead press: 3 sets of 10 reps.\n"
            "5. Deadlifts: 3 sets of 10 reps (use dumbbells if available).\n"
            "6. Plank: 3 sets of 45 seconds.\n"
            "Rest 60 seconds between sets.",
        imageUrl: "assets/strength.png",
      ),
      Exercise(
        title: "Mobility Flow",
        duration: "15 min",
        level: "Beginner",
        instructions:
            "1. Deep breathing: 5 slow, deep breaths.\n"
            "2. Neck mobility: 5 slow circles each direction.\n"
            "3. Shoulder rolls: 10 forward, 10 backward.\n"
            "4. Thoracic spine rotations: 8 each side.\n"
            "5. Hip circles: 8 each direction.\n"
            "6. Ankle rotations: 8 each direction.\n"
            "7. Wrist and finger stretches: 30 seconds.\n"
            "8. Full body shake: 15 seconds.",
        imageUrl: "assets/mobility.png",
      ),
      Exercise(
        title: "Evening Wind Down",
        duration: "12 min",
        level: "Beginner",
        instructions:
            "1. Seated forward fold: hold for 1 minute.\n"
            "2. Reclined butterfly pose: hold for 2 minutes.\n"
            "3. Supine spinal twist: 1 minute each side.\n"
            "4. Legs up the wall: hold for 3 minutes.\n"
            "5. Deep breathing: 5 minutes of 4-7-8 breathing.\n"
            "6. Final relaxation: 2 minutes of stillness.",
        imageUrl: "assets/winddown.png",
      ),
    ];
  }

  /// Returns a list of mock exercises for "Recommended for you"
  static List<Exercise> recommendedExercises() {
    return [
      Exercise(
        title: "Deep Neck Flexion",
        duration: "10 min",
        level: "Intermediate",
        instructions:
            "1. Sit upright with shoulders relaxed.\n"
            "2. Slowly tuck your chin toward your chest.\n"
            "3. Hold for 5 seconds, feeling a stretch in the back of your neck.\n"
            "4. Return to starting position.\n"
            "5. Repeat 10 times.\n"
            "6. Then, tilt your head to the right, holding for 15 seconds.\n"
            "7. Repeat on the left side.\n"
            "8. Finish with 5 slow neck rolls in each direction.",
        imageUrl: "assets/neck_correction.png",
      ),
      Exercise(
        title: "Wall Angels",
        duration: "8 min",
        level: "Beginner",
        instructions:
            "1. Stand with your back against a wall.\n"
            "2. Press your lower back, upper back, and head against the wall.\n"
            "3. Raise your arms to form a 'W' shape (elbows bent at 90°).\n"
            "4. Slowly slide your arms upward into a 'Y' shape.\n"
            "5. Keep your wrists, elbows, and shoulders against the wall.\n"
            "6. Lower back down to 'W' position.\n"
            "7. Perform 10 slow, controlled reps.\n"
            "8. Rest for 30 seconds, then repeat for another set.",
        imageUrl: "assets/wall_angels.png",
      ),
      Exercise(
        title: "Cat-Cow Stretch",
        duration: "5 min",
        level: "Beginner",
        instructions:
            "1. Start on your hands and knees in a tabletop position.\n"
            "2. Inhale as you drop your belly, lift your chest and tailbone (Cow pose).\n"
            "3. Exhale as you round your spine, tuck your chin and tailbone (Cat pose).\n"
            "4. Move slowly and deliberately with your breath.\n"
            "5. Repeat for 10 slow cycles.\n"
            "6. Finish by sitting back on your heels in Child's Pose for 30 seconds.",
        imageUrl: "assets/cat_cow.png",
      ),
      Exercise(
        title: "Chest Opener Stretch",
        duration: "5 min",
        level: "Beginner",
        instructions:
            "1. Stand tall with feet hip-width apart.\n"
            "2. Clasp your hands behind your back.\n"
            "3. Straighten your arms and gently lift them upward.\n"
            "4. Open your chest and hold for 20 seconds.\n"
            "5. Release and shake out your arms.\n"
            "6. Place your right hand on a wall or doorframe at shoulder height.\n"
            "7. Gently rotate your body away from the wall.\n"
            "8. Hold for 20 seconds, then switch sides.\n"
            "Repeat the sequence 2 times.",
        imageUrl: "assets/chest_opener.png",
      ),
      Exercise(
        title: "Thoracic Extension",
        duration: "5 min",
        level: "Intermediate",
        instructions:
            "1. Sit on a chair with your hands behind your head.\n"
            "2. Lean back over the backrest of the chair.\n"
            "3. Let your head gently drop back.\n"
            "4. Hold for 10 seconds, then return upright.\n"
            "5. Repeat 8 times.\n"
            "6. Next, use a foam roller placed under your upper back.\n"
            "7. Gently roll from mid-back to upper back for 2 minutes.\n"
            "8. Finish with 3 deep breaths in an extended position.",
        imageUrl: "assets/thoracic.png",
      ),
      Exercise(
        title: "Scapular Squeezes",
        duration: "3 min",
        level: "Beginner",
        instructions:
            "1. Sit or stand with good posture.\n"
            "2. Squeeze your shoulder blades together.\n"
            "3. Hold the squeeze for 5 seconds.\n"
            "4. Release completely.\n"
            "5. Repeat 15 times.\n"
            "6. Then, perform 10 shoulder rolls backward.\n"
            "7. Finish with 10 shoulder rolls forward.",
        imageUrl: "assets/scapular.png",
      ),
      Exercise(
        title: "Plank for Stability",
        duration: "3 min",
        level: "Advanced",
        instructions:
            "1. Start in a forearm plank position.\n"
            "2. Keep your body in a straight line from head to heels.\n"
            "3. Engage your core and glutes.\n"
            "4. Hold for 30 seconds.\n"
            "5. Rest for 15 seconds.\n"
            "6. Repeat for 3 more rounds.\n"
            "7. For an extra challenge, lift one leg at a time for 5 seconds each.",
        imageUrl: "assets/plank.png",
      ),
      Exercise(
        title: "Bird-Dog Exercise",
        duration: "10 min",
        level: "Intermediate",
        instructions:
            "1. Start on your hands and knees in a tabletop position.\n"
            "2. Extend your right arm forward and left leg backward simultaneously.\n"
            "3. Keep your hips and shoulders square to the floor.\n"
            "4. Hold for 3 seconds.\n"
            "5. Return to starting position.\n"
            "6. Repeat with left arm and right leg.\n"
            "7. Perform 10 reps on each side.\n"
            "8. Rest for 30 seconds, then complete 2 more sets.",
        imageUrl: "assets/bird_dog.png",
      ),
    ];
  }
}