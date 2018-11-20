# Write a Scheme in Haskell
Practice coding in Haskell following [Write Yourself a Scheme in 48 Hours/Parsing](https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours/Parsing).


## Dependency
- stack
- hspec-discover (for testing)
    - Can be installed as follows:
    ```shell
    $ stack install hspec-discover
    ```


## Build
```shell
$ stack build
```


## Test
- Test once:
```shell
$ stack test
```
- Test on updates:
```shell
$ stack test --fast --watch-files
```


## Run
```shell
$ stack exec -- scheme-in-haskell-exe
```

