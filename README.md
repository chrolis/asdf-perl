# asdf-perl

Perl plugin for asdf version manager

## Default modules

asdf-perl can automatically install a set of default modules right after installing a Perl version. To enable this feature, provide a `$HOME/.default-perl-modules` file that lists one module per line, for example:

```
Carton
App::cpm
```

You can specify a non-default location of this file by setting a `ASDF_PERL_DEFAULT_MODULES_FILE` variable.
