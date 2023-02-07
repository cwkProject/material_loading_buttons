## Features

Simple loadable button implemented based on flutter material design buttons.

[Material3 example](./example/screenshot/example.gif)

* ElevatedButton implemented
* FilledButton implemented
* Filled tonal button implemented
* OutlinedButton implemented
* TextButton implemented
* The loading status can be controlled
* Loading icon and label can be defined
* Implementation of automatic loading status management
* No additional styles

## Getting started

```yaml
material_loading_buttons: ^1.0.0
```

## Usage

```dart

// Automatic management status
ElevatedAutoLoadingButton(
  onPressed: () async{
    // load
    // Exit the loading state when future finished
  },
  child: const Text('ElevatedAutoLoadingButton'),
);

bool _isLoading = false;

// Manual management status
ElevatedLoadingButton(
  isLoading: _isLoading,
  onPressed: () async{
    setState((){
      _isLoading = true;
    });
    
    // load

    setState((){
      _isLoading = false;
    });
  },
  child: const Text('ElevatedLoadingButton'),
);

// define styles
ElevatedAutoLoadingButton(
  style: ElevatedButton.styleFrom(), // original

  // Any widget, Use default CircularProgressIndicator if null
  loadingIcon: const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(color: Colors.red),
  ),

  // Any widget, nullable
  loadingLabel: Text('loading...', style: TextStyle(color: Colors.red)),
  onPressed: () async{},
  child: const Text('ElevatedAutoLoadingButton'),
);

```

Other versions button: `FilledLoadingButton`,`FilledAutoLoadingButton`,`OutlinedLoadingButton`,`OutlinedAutoLoadingButton`,`TextLoadingButton`,`TextAutoLoadingButton`.
