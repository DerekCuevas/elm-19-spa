# Elm 0.19 SPA

## Installation

```sh
$ yarn
$ yarn run config
$ yarn dev
```

Open http://localhost:3000 and start modifying the code in /src.

## Production

Build production assets (js and css together) with:

```sh
$ yarn prod
```

## Static assets

Just add to `src/assets/` and the production build copies them to `/dist`

## Testing

[Install elm-test globally](https://github.com/elm-community/elm-test#running-tests-locally)

`elm-test init` is run when you install your dependencies. After that all you need to do to run the tests is

```
yarn test
```

Take a look at the examples in `tests/`

If you add dependencies to your main app, then run `elm-test --add-dependencies`
