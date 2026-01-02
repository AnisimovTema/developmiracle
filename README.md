# developmiracle
 
## store providing

first variation: ` final store = StoreProvider.of<AppState>(context); `
second variation: ` StoreConnector<AppState, Store<AppState>>(builder: () {}, converter: () {}), `

## localization

this project generates localized messages based on arb files found in
the `lib/src/localization` directory

<!-- to re-generate intl files, use `flutter gen-l10n --arb-dir=lib/src/localization --template-arb-file=app_en.arb --output-dir=lib/src/localization/generated` command  -->

>> to re-generate intl files, use `flutter gen-l10n --arb-dir=lib/src/localization --template-arb-file=app_en.arb --output-dir=lib/flutter_gen/gen_l10n` command 

## build_runner

`flutter pub run build_runner build --delete-conflicting-outputs`

## formatter

`dart format --line-length 80`

## prod build

`fvm flutter build web --release --no-tree-shake-icons`