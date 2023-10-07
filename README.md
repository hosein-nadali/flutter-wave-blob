## Features

### Blob Wave Animation
This package provide a blob wave animation that can be customized to your needs. You can playing audio using **amplitude** of voice.

# Preview
<img src="https://github.com/hosein-nadali/flutter-wave-blob/blob/main/example-1.gif?raw=true" width=300 />

## Getting started

### Installing
1. Add dependencies to `pubspec.yaml`

```dependencies
dependencies:
    wave_blob: <latest-version>
```
2. Run pub get.
```
flutter pub get
```
3. Import package
```dart
import 'package:wave_blob/wave_blob.dart';
```

## Usage

#### Simple usage

1. Wrap Widget with **WaveBlob** and assign needed parameter.
```dart
SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.4,
    height: MediaQuery.sizeOf(context).width * 0.4,
    child: WaveBlob(
        child: const Icon(
            Icons.mic,
            color: Colors.white,
            size: 50.0,
        ),
    ),
),
```

<br>

> Don't forget set **Width** and **Height** of widget.

<br>

> Check [example](https://www.google.com) app for more info.

### Customization

You can customize blob easily. You can change blob color, animation speed, min and max radius and etc. 

<br>

Example:

<br>

<img src="https://raw.githubusercontent.com/hosein-nadali/flutter-wave-blob/main/example-2.png" width=300 /> <img src="https://raw.githubusercontent.com/hosein-nadali/flutter-wave-blob/main/example-3.png" width=300 />


# Author
- **Hosein Nadalizadeh**
- [Telegram/BlobDrawable](https://github.com/DrKLO/Telegram/blob/master/TMessagesProj/src/main/java/org/telegram/ui/Components/BlobDrawable.java)

