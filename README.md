An animated progress bar widget designed to be used with audio or video.

<!-- ![Audio demo]() -->


## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
ProgressBar(
    controller: _controller,
    progress: const Duration(seconds: 30),
    buffered: const Duration(seconds: 35),
    total: const Duration(minutes: 1),
    onSeek: (position) {
        print('New position: $position');
    },
);
```


## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
