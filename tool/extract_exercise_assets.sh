#!/bin/zsh
set -euo pipefail

# Export every pose from the legacy contact sheets into its own image file.
# sips accepts a normal top-left crop offset. The offset must be supplied before
# the crop operation; otherwise it silently uses the centre of the contact sheet.
crop_pose() {
  local source="$1" source_width="$2" source_height="$3"
  local x="$4" y="$5" width="$6" height="$7" name="$8"
  sips --cropOffset "$y" "$x" \
    --cropToHeightWidth "$height" "$width" \
    "$source" --out "assets/images/exercise_${name}.png" >/dev/null
}

cardio="assets/images/exercises_cardio_yoga_grid.png"
crop_pose "$cardio" 1024 1536 0   0   254 492 barbell_squat
crop_pose "$cardio" 1024 1536 259 0   251 492 bench_press
crop_pose "$cardio" 1024 1536 514 0   251 492 pull_up
crop_pose "$cardio" 1024 1536 770 0   254 492 overhead_press
crop_pose "$cardio" 1024 1536 0   497 254 468 sprint
crop_pose "$cardio" 1024 1536 259 497 251 468 jump_rope
crop_pose "$cardio" 1024 1536 514 497 251 468 high_knees
crop_pose "$cardio" 1024 1536 770 497 254 468 kettlebell_swing
crop_pose "$cardio" 1024 1536 0   970 254 566 sun_salutation
crop_pose "$cardio" 1024 1536 259 970 251 566 warrior_pose
crop_pose "$cardio" 1024 1536 514 970 251 566 cobra_pose
crop_pose "$cardio" 1024 1536 770 970 254 566 pigeon_stretch

core="assets/images/exercises_core_mobility_grid.png"
crop_pose "$core" 1225 1284 0   0   291 375 plank_hold
crop_pose "$core" 1225 1284 298 0   312 375 bicycle_crunch
crop_pose "$core" 1225 1284 616 0   314 375 russian_twist
crop_pose "$core" 1225 1284 936 0   289 375 leg_raise
crop_pose "$core" 1225 1284 0   380 291 410 cat_cow
crop_pose "$core" 1225 1284 298 380 312 410 deep_squat
crop_pose "$core" 1225 1284 616 380 314 410 thoracic_rotation
crop_pose "$core" 1225 1284 936 380 289 410 downward_dog_cobra
crop_pose "$core" 1225 1284 0   796 291 488 dumbbell_row
crop_pose "$core" 1225 1284 298 796 312 488 goblet_squat
crop_pose "$core" 1225 1284 616 796 314 488 jump_lunge
crop_pose "$core" 1225 1284 936 796 289 488 full_body_stretch

level="assets/images/exercises_level_grid.png"
crop_pose "$level" 1222 1287 0   0   264 390 bodyweight_squat
crop_pose "$level" 1222 1287 270 0   336 390 incline_push_up
crop_pose "$level" 1222 1287 613 0   288 390 glute_bridge
crop_pose "$level" 1222 1287 909 0   313 390 bird_dog
crop_pose "$level" 1222 1287 0   397 264 399 reverse_lunge
crop_pose "$level" 1222 1287 270 397 336 399 standard_push_up
crop_pose "$level" 1222 1287 613 397 288 399 shoulder_press
crop_pose "$level" 1222 1287 909 397 313 399 mountain_climber
crop_pose "$level" 1222 1287 0   803 264 484 jump_squat
crop_pose "$level" 1222 1287 270 803 336 484 burpee
crop_pose "$level" 1222 1287 613 803 288 484 single_leg_deadlift
crop_pose "$level" 1222 1287 909 803 313 484 plank_jack
