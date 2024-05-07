import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../widgets/overlays/pause_menu.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/game_over_menu.dart';

import '../models/player_data.dart';
import '../models/spaceship_details.dart';

import 'enemy.dart';
import 'health_bar.dart';
import 'player.dart';
import 'bullet.dart';
import 'command.dart';
import 'power_ups.dart';
import 'enemy_manager.dart';
import 'power_up_manager.dart';
import 'audio_player_component.dart';
import 'dart:ui' as ui;

// This class is responsible for initializing and running the game-loop.
class SpacescapeGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // Variáveis para controlar o número de inimigos de cada cor
  int redEnemyCount = 0;
  int greenEnemyCount = 0;

  // Flag para alternar entre vermelho e verde
  bool isRed = true;


  // The whole game world.
  final World world = World();

  late CameraComponent primaryCamera;

  // Stores a reference to player component.
  late Player _player;

  // Stores a reference to the main spritesheet.
  late SpriteSheet spriteSheet;

  // Stores a reference to an enemy manager component.
  late EnemyManager _enemyManager;

  // Stores a reference to an power-up manager component.
  late PowerUpManager _powerUpManager;

  // Displays player score on top left.
  late TextComponent _playerScore;

  // Displays player helth on top right.
  late TextComponent _playerHealth;

  late AudioPlayerComponent _audioPlayerComponent;

  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  // Indicates weather the game world has been already initialized.
  bool _isAlreadyLoaded = false;

  // Returns the size of the playable area of the game window.
  Vector2 fixedResolution = Vector2(540, 960);

  ButtonComponent? button;
  ButtonComponent? button2;

  // Método para alternar entre vermelho e verde com base no número de inimigos de cada cor
  Color getNextEnemyColor() {
    // Se a flag indicar vermelho e houver mais inimigos vermelhos, mude para verde
    if (isRed && redEnemyCount > greenEnemyCount) {
      isRed = false;
      greenEnemyCount++;
      return Colors.green;
    }
    // Se a flag indicar verde e houver mais inimigos verdes, mude para vermelho
    else if (!isRed && greenEnemyCount > redEnemyCount) {
      isRed = true;
      redEnemyCount++;
      return Colors.red;
    }
    // Se a flag indicar vermelho ou ambos os contadores de inimigos forem iguais, mantenha vermelho
    else if (isRed || (redEnemyCount == greenEnemyCount)) {
      isRed = true;
      redEnemyCount++;
      return Colors.red;
    }
    // Caso contrário, mude para verde
    else {
      isRed = false;
      greenEnemyCount++;
      return Colors.green;
    }
  }

  // Método para aplicar o filtro de cor à imagem do inimigo
  Future<ui.Image> applyColorFilterToEnemy(ui.Image image) async {
    // Obtenha a próxima cor para o próximo inimigo
    Color color = getNextEnemyColor();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // Desenha a imagem com o filtro de pintura
    final paint = ui.Paint()..colorFilter = ui.ColorFilter.mode(color, ui.BlendMode.srcIn);
    canvas.drawImage(image, ui.Offset.zero, paint);

    // Conclui a gravação e retorna a imagem com o filtro aplicado
    final picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // Initialize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      await images.loadAll([
        'simpleSpace_tilesheet@2.png',
        'freeze.png',
        'icon_plusSmall.png',
        'multi_fire.png',
        'nuke.png'
      ]);

      // Obtenha a imagem do asset
      ui.Image spriteImage = images.fromCache('simpleSpace_tilesheet@2.png');

      // Aplicando filtro de cor para o inimigo
      ui.Image coloredSpriteImage = await applyColorFilterToEnemy(spriteImage);


      // Criar um SpriteSheet com a nova imagem filtrada
      spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: coloredSpriteImage,
        columns: 8,
        rows: 6,
      );

      await add(world);
      // Create a basic joystick component on left.
      final joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(30, fixedResolution.y - 200),
        // size: 100,
        background: CircleComponent(
          radius: 60,
          paint: Paint()..color = Color.fromARGB(255, 62, 4, 221).withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 30),
      );

      primaryCamera = CameraComponent.withFixedResolution(
        world: world,
        width: fixedResolution.x,
        height: fixedResolution.y,
        hudComponents: [joystick],
      )..viewfinder.position = fixedResolution / 2;
      await add(primaryCamera);

      _audioPlayerComponent = AudioPlayerComponent();
      final stars = await ParallaxComponent.load(
        [ParallaxImageData('stars1.png'), ParallaxImageData('stars2.png')],
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(0, -50),
        velocityMultiplierDelta: Vector2(0, 1.5),
        size: fixedResolution,
      );



      /// As build context is not valid in onLoad() method, we
      /// cannot get current [PlayerData] here. So initilize player
      /// with the default SpaceshipType.Canary.
      const spaceshipType = SpaceshipType.canary;
      final spaceship = Spaceship.getSpaceshipByType(spaceshipType);

      _player = Player(
        joystick: joystick,
        spaceshipType: spaceshipType,
        sprite: spriteSheet.getSpriteById(spaceship.spriteId),
        size: Vector2(64, 64),
        position: fixedResolution / 2,
      );

      // Makes sure that the sprite is centered.
      _player.anchor = Anchor.center;

      _enemyManager = EnemyManager(spriteSheet: spriteSheet);
      _powerUpManager = PowerUpManager();

      // Create a fire button component on right
      button = ButtonComponent(
        button: CircleComponent(
          radius: 60,
          paint: Paint()..color = Color.fromARGB(255, 24, 253, 3).withOpacity(0.5),
        ),
        anchor: Anchor.bottomRight,
        position: Vector2(fixedResolution.x - 30, fixedResolution.y - 30),
        onPressed: _player.joystickAction,
      );

      // Create a fire button component on right
      button2 = ButtonComponent(
        button: CircleComponent(
          radius: 60,
          paint: Paint()..color = Color.fromARGB(255, 9, 234, 159).withOpacity(0.5),
        ),
        anchor: Anchor.bottomRight,
        position: Vector2(fixedResolution.x - 200, fixedResolution.y - 30),
        onPressed: _player.joystickAction,
      );

      // Create text component for player score.
      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(10, 10),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      // Create text component for player health.
      _playerHealth = TextComponent(
        text: 'Health: 100%',
        position: Vector2(fixedResolution.x - 10, 10),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      // Anchor to top right as we want the top right
      // corner of this component to be at a specific position.
      _playerHealth.anchor = Anchor.topRight;

      // Add the blue bar indicating health.
      final healthBar = HealthBar(
        player: _player,
        position: _playerHealth.positionOfAnchor(Anchor.topLeft),
        priority: -1,
      );

      // Makes the game use a fixed resolution irrespective of the windows size.
      await world.addAll([
        _audioPlayerComponent,
        stars,
        _player,
        _enemyManager,
        _powerUpManager,
        button!,
        button2!,
        _playerScore,
        _playerHealth,
        healthBar,
      ]);

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  // This method gets called when game instance gets attached
      // to Flutter's widget tree.
      @override
      void onAttach() {
        if (buildContext != null) {
          // Get the PlayerData from current build context without registering a listener.
          final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
          // Update the current spaceship type of player.
          _player.setSpaceshipType(playerData.spaceshipType);
        }
        _audioPlayerComponent.playBgm('9. Space Invaders.wav');
        super.onAttach();
      }

      @override
      void onDetach() {
        _audioPlayerComponent.stopBgm();
        super.onDetach();
      }

      @override
      void update(double dt) {
        super.update(dt);

        // Run each command from _commandList on each
        // component from components list. The run()
        // method of Command is no-op if the command is
        // not valid for given component.
        for (var command in _commandList) {
          for (var component in world.children) {
            command.run(component);
          }
        }

        // Remove all the commands that are processed and
        // add all new commands to be processed in next update.
        _commandList.clear();
        _commandList.addAll(_addLaterCommandList);
        _addLaterCommandList.clear();

        if (_player.isMounted) {
          // Update score and health components with latest values.
          _playerScore.text = 'Score: ${_player.score}';
          _playerHealth.text = 'Health: ${_player.health}%';

          /// Display [GameOverMenu] when [Player.health] becomes
          /// zero and camera stops shaking.
          // if (_player.health <= 0 && (!camera.shaking)) {
          if (_player.health <= 0) {
            pauseEngine();
            overlays.remove(PauseButton.id);
            overlays.add(GameOverMenu.id);
          }
        }
      }

      // This method handles state of app and pauses
      // the game when necessary.
      @override
      void lifecycleStateChange(AppLifecycleState state) {
        switch (state) {
          case AppLifecycleState.resumed:
            break;
          case AppLifecycleState.inactive:
          case AppLifecycleState.paused:
          case AppLifecycleState.detached:
          case AppLifecycleState.hidden:
            if (_player.health > 0) {
              pauseEngine();
              overlays.remove(PauseButton.id);
              overlays.add(PauseMenu.id);
            }
            break;
        }

        super.lifecycleStateChange(state);
      }

      // Adds given command to command list.
      void addCommand(Command command) {
        _addLaterCommandList.add(command);
      }

      // Resets the game to inital state. Should be called
      // while restarting and exiting the game.
      void reset() {
        // First reset player, enemy manager and power-up manager .
        _player.reset();
        _enemyManager.reset();
        _powerUpManager.reset();

        // Now remove all the enemies, bullets and power ups
        // from the game world. Note that, we are not calling
        // Enemy.destroy() because it will unnecessarily
        // run explosion effect and increase players score.
        world.children.whereType<Enemy>().forEach((enemy) {
          enemy.removeFromParent();
        });

        world.children.whereType<Bullet>().forEach((bullet) {
          bullet.removeFromParent();
        });

        world.children.whereType<PowerUp>().forEach((powerUp) {
          powerUp.removeFromParent();
        });
      }
    }
