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
cd "C:\Users\HP\Documents\Ejercicio 2"

# Limpiar si existe
rm -rf MusicPlayerApp 2>/dev/null

# Crear y navegar
mkdir -p MusicPlayerApp && cd MusicPlayerApp

# Crear solución
dotnet new sln -n MusicPlayerApp

# Crear proyecto principal
dotnet new console -n MusicPlayer
dotnet sln add MusicPlayer/MusicPlayer.csproj

# Crear archivos de código
cat > MusicPlayer/IMusicCommand.cs << 'EOF'
namespace MusicPlayer
{
    public interface IMusicCommand
    {
        string Execute();
    }
}
