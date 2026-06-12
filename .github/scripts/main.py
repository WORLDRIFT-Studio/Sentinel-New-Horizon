import os


def get_nightly_version() -> str:
    """Get the nightly version number from the environment variable GITHUB_RUN_NUMBER."""
    version: str = os.getenv('GITHUB_RUN_NUMBER', 'dev')
    return version


def update_project_version() -> None:
    """Update the version number in the project.godot file to include the nightly version."""
    with open('project.godot', 'r', encoding='utf-8') as f:
        lines: list[str] = f.readlines()

    for i, line in enumerate(lines):
        if line.startswith('config/version='):
            base_version: str = line.split('"')[1]
            full_version: str = base_version.split('-')[0]
            nightly_version: str = get_nightly_version()
            lines[i] = f'config/version="{full_version}-nightly.{nightly_version}"\n'
            break

    with open('project.godot', 'w', encoding='utf-8') as f:
        f.writelines(lines)


def get_project_info() -> None:
    """Get the project information from the project.godot file and inject it into the environment variables."""
    game_name: str = 'game'
    game_version: str = 'dev'

    with open('project.godot', 'r', encoding='utf-8') as f:
        lines: list[str] = f.readlines()

    for line in lines:
        if line.startswith('config/name='):
            game_name = line.split('"')[1]
        elif line.startswith('config/version='):
            game_version = line.split('"')[1]   

    file_name: str = f'{game_name}_{game_version}'
    if 'GITHUB_ENV' in os.environ:
        with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as f:
            f.write(f'GAME_NAME={game_name}\n')
            f.write(f'GAME_VERSION={game_version}\n')
            f.write(f'FILE_NAME={file_name}\n')

if __name__ == "__main__":
    update_project_version()
    get_project_info()
