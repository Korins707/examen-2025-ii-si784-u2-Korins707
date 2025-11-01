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
