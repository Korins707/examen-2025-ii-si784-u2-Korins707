#!/bin/bash

# Script para configurar el proyecto completo de MusicPlayer con pruebas y CI/CD
# Ruta: C:\Users\HP\Documents\Ejercicio 2

echo "======================================"
echo "Configurando proyecto MusicPlayer"
echo "======================================"

# Navegar a la ruta especificada
cd "C:\Users\HP\Documents\Ejercicio 2" || cd "/c/Users/HP/Documents/Ejercicio 2"

# Limpiar si existe
if [ -d "MusicPlayerApp" ]; then
    echo "Eliminando carpeta existente..."
    rm -rf MusicPlayerApp
fi

# Crear estructura del proyecto
mkdir -p MusicPlayerApp
cd MusicPlayerApp

# Crear solución
dotnet new sln -n MusicPlayerApp

# ===================================
# PROYECTO PRINCIPAL
# ===================================
echo ""
echo "Creando proyecto principal..."
dotnet new console -n MusicPlayer
dotnet sln add MusicPlayer/MusicPlayer.csproj

# Crear IMusicCommand.cs
cat > MusicPlayer/IMusicCommand.cs << 'EOF'
namespace MusicPlayer
{
    public interface IMusicCommand
    {
        string Execute();
    }
}
EOF

# Crear MusicPlayer.cs
cat > MusicPlayer/MusicPlayer.cs << 'EOF'
namespace MusicPlayer
{
    public class MusicPlayer
    {
        public string Play()
        {
            return "Playing the song.";
        }

        public string Pause()
        {
            return "Pausing the song.";
        }

        public string Skip()
        {
            return "Skipping to the next song.";
        }
    }
}
EOF

# Crear PlayCommand.cs
cat > MusicPlayer/PlayCommand.cs << 'EOF'
namespace MusicPlayer
{
    public class PlayCommand : IMusicCommand
    {
        private readonly MusicPlayer _player;

        public PlayCommand(MusicPlayer player)
        {
            _player = player;
        }

        public string Execute()
        {
            return _player.Play();
        }
    }
}
EOF

# Crear PauseCommand.cs
cat > MusicPlayer/PauseCommand.cs << 'EOF'
namespace MusicPlayer
{
    public class PauseCommand : IMusicCommand
    {
        private readonly MusicPlayer _player;

        public PauseCommand(MusicPlayer player)
        {
            _player = player;
        }

        public string Execute()
        {
            return _player.Pause();
        }
    }
}
EOF

# Crear SkipCommand.cs
cat > MusicPlayer/SkipCommand.cs << 'EOF'
namespace MusicPlayer
{
    public class SkipCommand : IMusicCommand
    {
        private readonly MusicPlayer _player;

        public SkipCommand(MusicPlayer player)
        {
            _player = player;
        }

        public string Execute()
        {
            return _player.Skip();
        }
    }
}
EOF

# Crear MusicRemote.cs
cat > MusicPlayer/MusicRemote.cs << 'EOF'
namespace MusicPlayer
{
    public class MusicRemote
    {
        private IMusicCommand? _command;

        public void SetCommand(IMusicCommand command)
        {
            _command = command;
        }

        public string PressButton()
        {
            if (_command == null)
            {
                return "No command set.";
            }
            return _command.Execute();
        }
    }
}
EOF

# Crear Program.cs
cat > MusicPlayer/Program.cs << 'EOF'
using MusicPlayer;

Console.WriteLine("=== Music Player Command Pattern Demo ===\n");

var player = new MusicPlayer.MusicPlayer();
var playCommand = new PlayCommand(player);
var pauseCommand = new PauseCommand(player);
var skipCommand = new SkipCommand(player);
var remote = new MusicRemote();

Console.WriteLine("Pressing Play button:");
remote.SetCommand(playCommand);
Console.WriteLine(remote.PressButton());

Console.WriteLine("\nPressing Pause button:");
remote.SetCommand(pauseCommand);
Console.WriteLine(remote.PressButton());

Console.WriteLine("\nPressing Skip button:");
remote.SetCommand(skipCommand);
Console.WriteLine(remote.PressButton());
EOF

# ===================================
# PRUEBAS UNITARIAS
# ===================================
echo ""
echo "Creando proyecto de pruebas unitarias..."
dotnet new xunit -n MusicPlayer.Tests
dotnet sln add MusicPlayer.Tests/MusicPlayer.Tests.csproj
cd MusicPlayer.Tests
dotnet add reference ../MusicPlayer/MusicPlayer.csproj
dotnet add package coverlet.collector
dotnet add package coverlet.msbuild
cd ..

# MusicPlayerTests.cs
cat > MusicPlayer.Tests/MusicPlayerTests.cs << 'EOF'
using Xunit;

namespace MusicPlayer.Tests
{
    public class MusicPlayerTests
    {
        [Fact]
        public void Play_ShouldReturnPlayingMessage()
        {
            var player = new MusicPlayer.MusicPlayer();
            var result = player.Play();
            Assert.Equal("Playing the song.", result);
        }

        [Fact]
        public void Pause_ShouldReturnPausingMessage()
        {
            var player = new MusicPlayer.MusicPlayer();
            var result = player.Pause();
            Assert.Equal("Pausing the song.", result);
        }

        [Fact]
        public void Skip_ShouldReturnSkippingMessage()
        {
            var player = new MusicPlayer.MusicPlayer();
            var result = player.Skip();
            Assert.Equal("Skipping to the next song.", result);
        }
    }
}
EOF

# PlayCommandTests.cs
cat > MusicPlayer.Tests/PlayCommandTests.cs << 'EOF'
using Xunit;

namespace MusicPlayer.Tests
{
    public class PlayCommandTests
    {
        [Fact]
        public void Execute_ShouldCallPlayOnMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new PlayCommand(player);
            var result = command.Execute();
            Assert.Equal("Playing the song.", result);
        }

        [Fact]
        public void Constructor_ShouldAcceptMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new PlayCommand(player);
            Assert.NotNull(command);
        }
    }
}
EOF

# PauseCommandTests.cs
cat > MusicPlayer.Tests/PauseCommandTests.cs << 'EOF'
using Xunit;

namespace MusicPlayer.Tests
{
    public class PauseCommandTests
    {
        [Fact]
        public void Execute_ShouldCallPauseOnMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new PauseCommand(player);
            var result = command.Execute();
            Assert.Equal("Pausing the song.", result);
        }

        [Fact]
        public void Constructor_ShouldAcceptMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new PauseCommand(player);
            Assert.NotNull(command);
        }
    }
}
EOF

# SkipCommandTests.cs
cat > MusicPlayer.Tests/SkipCommandTests.cs << 'EOF'
using Xunit;

namespace MusicPlayer.Tests
{
    public class SkipCommandTests
    {
        [Fact]
        public void Execute_ShouldCallSkipOnMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new SkipCommand(player);
            var result = command.Execute();
            Assert.Equal("Skipping to the next song.", result);
        }

        [Fact]
        public void Constructor_ShouldAcceptMusicPlayer()
        {
            var player = new MusicPlayer.MusicPlayer();
            var command = new SkipCommand(player);
            Assert.NotNull(command);
        }
    }
}
EOF

# MusicRemoteTests.cs
cat > MusicPlayer.Tests/MusicRemoteTests.cs << 'EOF'
using Xunit;

namespace MusicPlayer.Tests
{
    public class MusicRemoteTests
    {
        [Fact]
        public void SetCommand_ShouldAcceptCommand()
        {
            var remote = new MusicRemote();
            var player = new MusicPlayer.MusicPlayer();
            var command = new PlayCommand(player);
            remote.SetCommand(command);
            Assert.NotNull(remote);
        }

        [Fact]
        public void PressButton_WithPlayCommand_ShouldReturnPlayMessage()
        {
            var remote = new MusicRemote();
            var player = new MusicPlayer.MusicPlayer();
            var command = new PlayCommand(player);
            remote.SetCommand(command);
            var result = remote.PressButton();
            Assert.Equal("Playing the song.", result);
        }

        [Fact]
        public void PressButton_WithPauseCommand_ShouldReturnPauseMessage()
        {
            var remote = new MusicRemote();
            var player = new MusicPlayer.MusicPlayer();
            var command = new PauseCommand(player);
            remote.SetCommand(command);
            var result = remote.PressButton();
            Assert.Equal("Pausing the song.", result);
        }

        [Fact]
        public void PressButton_WithSkipCommand_ShouldReturnSkipMessage()
        {
            var remote = new MusicRemote();
            var player = new MusicPlayer.MusicPlayer();
            var command = new SkipCommand(player);
            remote.SetCommand(command);
            var result = remote.PressButton();
            Assert.Equal("Skipping to the next song.", result);
        }

        [Fact]
        public void PressButton_WithoutCommand_ShouldReturnNoCommandMessage()
        {
            var remote = new MusicRemote();
            var result = remote.PressButton();
            Assert.Equal("No command set.", result);
        }
    }
}
EOF

# ===================================
# PRUEBAS BDD
# ===================================
echo ""
echo "Creando proyecto de pruebas BDD..."
dotnet new xunit -n MusicPlayer.BDD.Tests
dotnet sln add MusicPlayer.BDD.Tests/MusicPlayer.BDD.Tests.csproj
cd MusicPlayer.BDD.Tests
dotnet add reference ../MusicPlayer/MusicPlayer.csproj
dotnet add package SpecFlow.xUnit
dotnet add package SpecFlow.Tools.MsBuild.Generation
dotnet add package coverlet.collector
cd ..

# Crear specflow.json
cat > MusicPlayer.BDD.Tests/specflow.json << 'EOF'
{
  "language": {
    "feature": "en"
  },
  "bindingCulture": {
    "name": "en"
  }
}
EOF

# Crear Features directory
mkdir -p MusicPlayer.BDD.Tests/Features

# MusicPlayer.feature
cat > MusicPlayer.BDD.Tests/Features/MusicPlayer.feature << 'EOF'
Feature: Music Player Commands
  As a user
  I want to control the music player with commands
  So that I can play, pause, and skip songs

  Scenario: Play a song
    Given I have a music player
    And I have a play command
    When I press the button on the remote
    Then I should see "Playing the song."

  Scenario: Pause a song
    Given I have a music player
    And I have a pause command
    When I press the button on the remote
    Then I should see "Pausing the song."

  Scenario: Skip to next song
    Given I have a music player
    And I have a skip command
    When I press the button on the remote
    Then I should see "Skipping to the next song."

  Scenario: Remote without command
    Given I have a music remote
    When I press the button without setting a command
    Then I should see "No command set."
EOF

# Crear Steps directory
mkdir -p MusicPlayer.BDD.Tests/Steps

# MusicPlayerSteps.cs
cat > MusicPlayer.BDD.Tests/Steps/MusicPlayerSteps.cs << 'EOF'
using Xunit;
using TechTalk.SpecFlow;

namespace MusicPlayer.BDD.Tests.Steps
{
    [Binding]
    public class MusicPlayerSteps
    {
        private MusicPlayer.MusicPlayer? _player;
        private MusicRemote? _remote;
        private string? _result;

        [Given(@"I have a music player")]
        public void GivenIHaveAMusicPlayer()
        {
            _player = new MusicPlayer.MusicPlayer();
            _remote = new MusicRemote();
        }

        [Given(@"I have a play command")]
        public void GivenIHaveAPlayCommand()
        {
            var command = new PlayCommand(_player!);
            _remote!.SetCommand(command);
        }

        [Given(@"I have a pause command")]
        public void GivenIHaveAPauseCommand()
        {
            var command = new PauseCommand(_player!);
            _remote!.SetCommand(command);
        }

        [Given(@"I have a skip command")]
        public void GivenIHaveASkipCommand()
        {
            var command = new SkipCommand(_player!);
            _remote!.SetCommand(command);
        }

        [Given(@"I have a music remote")]
        public void GivenIHaveAMusicRemote()
        {
            _remote = new MusicRemote();
        }

        [When(@"I press the button on the remote")]
        public void WhenIPressTheButtonOnTheRemote()
        {
            _result = _remote!.PressButton();
        }

        [When(@"I press the button without setting a command")]
        public void WhenIPressTheButtonWithoutSettingACommand()
        {
            _result = _remote!.PressButton();
        }

        [Then(@"I should see ""(.*)""")]
#!/bin/bash

# Script para configurar el proyecto completo de MusicPlayer con pruebas y CI/CD
# Ruta: C:\Users\HP\Documents\Ejercicio 2

echo "======================================"
echo "Configurando proyecto MusicPlayer"
echo "======================================"

# Navegar a la ruta especificada
cd "C:\Users\HP\Documents\Ejercicio 2" || cd "/c/Users/HP/Documents/Ejercicio 2"

# Limpiar si existe
if [ -d "MusicPlayerApp" ]; then
    echo "Eliminando carpeta existente..."
    rm -rf MusicPlayerApp
fi

# Crear estructura del proyecto
mkdir -p MusicPlayerApp
cd MusicPlayerApp

# Crear solución
dotnet new sln -n MusicPlayerApp

# ===================================
# PROYECTO PRINCIPAL
# ===================================
echo ""
echo "Creando proyecto principal..."
dotnet new console -n MusicPlayer
dotnet sln add MusicPlayer/MusicPlayer.csproj

# Crear IMusicCommand.cs
cat > MusicPlayer/IMusicCommand.cs << 'EOF'
namespace MusicPlayer
{
    public interface IMusicCommand
    {
        string Execute();
    }
}
EOF

# Crear MusicPlayer.cs
cat > MusicPlayer/MusicPlayer.cs << 'EOF'
namespace MusicPlayer
{
    public class MusicPlayer
    {
        public string Play()
        {
            return "Playing the song.";
        }

        public string Pause()
        {
            return "Pausing the song.";
        }

        public string Skip()
        {
            return "Skipping to the next song.";
        }
    }
}
EOF

# Crear PlayCommand.cs
cat > MusicPlayer/PlayCommand.cs << 'EOF'
namespace MusicPlayer
{
    public class PlayCommand : IMusicCommand
    {
        private readonly MusicPlayer _player;

        public PlayCommand(MusicPlayer player)
        {
            _player = player;
        }

        public string Execute()


