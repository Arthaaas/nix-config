{ self, inputs, ... }:
{
  flake.nixosModules.erpDevPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.erpDev.enable =
        lib.mkEnableOption "ERP development environment packages and local database";

      config = lib.mkIf config.my.packages.erpDev.enable {
        environment.systemPackages = with pkgs; [
          php
          phpPackages.composer
          mariadb
        ];

        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          ensureDatabases = [
            "erp-develop" # dev (erp, .env.example)
            "intranet" # dev (erp, .env.example)
            "erp" # testes (erp, .env.testing + phpunit.xml)
          ];
          settings.mysqld.bind-address = "127.0.0.1";
          # TCP local deve casar com 'root'@'127.0.0.1', como os .env esperam.
          settings.mysqld.skip-name-resolve = true;
          initialScript = pkgs.writeText "mysql-erp-dev-init.sql" ''
            CREATE USER IF NOT EXISTS 'root'@'127.0.0.1';
            GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
            CREATE USER IF NOT EXISTS 'erp'@'127.0.0.1' IDENTIFIED BY 'root';
            GRANT ALL PRIVILEGES ON *.* TO 'erp'@'127.0.0.1' WITH GRANT OPTION;
            CREATE USER IF NOT EXISTS 'erp-develop'@'127.0.0.1' IDENTIFIED BY '.k0t.1d4p';
            GRANT ALL PRIVILEGES ON *.* TO 'erp-develop'@'127.0.0.1' WITH GRANT OPTION;
            FLUSH PRIVILEGES;
          '';
        };
      };
    };
}
