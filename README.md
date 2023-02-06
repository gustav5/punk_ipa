# Punk Ipa search

To start your the application:
If you have elixir, phoenix and sqlite3 installed, then it should be enough with:
  * git clone https://github.com/gustav5/punk_ipa.git
  * cd punk_ipa/front 
  * mix deps.get 
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

If you don't have elixir, you can use the nix-shell. First you need to install nix at:
https://nixos.org/download.html . I don't know much about nix, but Single-user installation
works for me. Then do:
  * git clone https://github.com/gustav5/punk_ipa.git
  * cd punk_ipa/front
  * nix-shell 
  * mix deps.get 
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


App is located at (http://localhost:4000/search) from your browser.



