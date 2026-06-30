{ ... }:
let
  braveCommand = "env -u LC_ALL LANG=pt_BR.UTF-8 LC_TIME=pt_BR.UTF-8 brave --lang=pt-BR";
in
{
  flake.homeModules.brave =
    { ... }:
    {
      home.file.".local/share/applications/brave-browser.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Name=Brave Web Browser
        GenericName=Web Browser
        Comment=Access the Internet
        Exec=${braveCommand} %U
        StartupNotify=true
        Terminal=false
        Icon=brave-browser
        Type=Application
        Categories=Network;WebBrowser;
        MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/chromium;
        Actions=new-window;new-private-window;

        [Desktop Action new-window]
        Name=New Window
        Exec=${braveCommand}

        [Desktop Action new-private-window]
        Name=New Private Window
        Exec=${braveCommand} --incognito
      '';

      programs.fish.shellAliases = {
        brave = braveCommand;
      };
    };
}
