use bevy::prelude::*;

#[derive(Component)]
struct Player;

#[derive(Component)]
struct Obstacle;

#[derive(Component)]
struct Velocity(Vec2);

#[derive(Resource)]
struct GameSpeed(f32);

fn setup(mut commands: Commands) {
    commands.spawn(Camera2d);
    commands.insert_resource(GameSpeed(300.0));

    commands.spawn((
        Sprite {
            color: Color::srgb(0.2, 0.7, 0.9),
            custom_size: Some(Vec2::new(40.0, 60.0)),
            ..default()
        },
        Transform::from_xyz(-300.0, -100.0, 0.0),
        Player,
    ));
}

fn player_movement(
    keyboard_input: Res<ButtonInput<KeyCode>>,
    mut query: Query<&mut Transform, With<Player>>,
) {
    for mut transform in &mut query {
        if keyboard_input.just_pressed(KeyCode::Space) {
            transform.translation.y += 150.0;
        }
    }
}

fn move_obstacles(
    game_speed: Res<GameSpeed>,
    mut query: Query<(&mut Transform, &Velocity), With<Obstacle>>,
    time: Res<Time>,
) {
    for (mut transform, velocity) in &mut query {
        transform.translation.x -= (game_speed.0 + velocity.0.x) * time.delta_secs();
    }
}

fn despawn_offscreen(
    mut commands: Commands,
    query: Query<(Entity, &Transform), With<Obstacle>>,
) {
    for (entity, transform) in &query {
        if transform.translation.x < -700.0 {
            commands.entity(entity).despawn();
        }
    }
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, setup)
        .add_systems(Update, (player_movement, move_obstacles, despawn_offscreen))
        .run();
}
