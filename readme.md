[FileCloud][filecloud-site] is an enterprise grade file sharing, sync, and backup solution developed by [CodeLathe][codelathe-github] that can be self-hosted (on-prem). They provide [sync clients][filecloud-dlpage] for Windows, Mac, and Linux.

For Linux, the [documented installation process][fc-install-linux] involves downloading and unzipping their latest archive, making a couple files executable, and then running one of them to setup the sync app... which may work, providing all dependencies are met.

As user Ilsa Loving [calls out][fc-comm-link] on their community forums, the process leaves a bit to be desired; I have also elaborated a bit on [my blog][blog-link].

I made a *crude* script to install the current sync client (18.2.0.1012) on my current preferred flavor, Kubuntu 18.10; it should work on any recent [(.?[Uu]buntu)][regex-nonsense] release.

Run the following from your terminal (does not require sudo access)...

```
git clone https://github.com/derek-shnosh/filecloudsync-install.git ~/Downloads/filecloudsync-install
chmod +x ~/Downloads/filecloudsync-install.sh
~/Downloads/filecloudsync-install/filecloudsync-install.sh
```

What this does...

1. Clones the github repo to `~/Downloads/filecloundsync-install/`.
   - Contains my installer script and a .png file to be used for the icon.
2. Makes the installation script executable.
3. Runs the installation script.
   - Downloads the latest sync client from FileCloud servers.
   - Downloads libpng12 from Ubuntu.
   - Installs prerequisites (`libpng12` and `libdbusmenu-gtk-dev`).
   - Unzips the sync client to `~/App/filecloudsync`.
   - Copies the .png file to `~/App/filecloudsync`.
   - Makes required files executable (`filecloudsync`, `filecloudsyncstart`).
   - Creates a `filecloudsync.desktop` file in `~/.local/share/applications/`.
   - The sync client can now be launched from an app menu.





[filecloud-site]: https://www.getfilecloud.com/
[codelathe-github]: https://github.com/codelathe
[filecloud-dlpage]: https://www.getfilecloud.com/additional-downloads/
[fc-install-linux]: https://www.getfilecloud.com/supportdocs/display/cloud/Install+Sync+on+Linux
[fc-comm-link]: https://community.getfilecloud.com/topic/linux-sync-client-hopelessly-inadequate
[blog-link]: https://shnosh.io/linux-filecloudsync-install
[regex-nonsense]: https://regex101.com/r/o4CJvI/1