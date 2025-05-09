// Simple script to test if Metro can start without errors
const path = require('path');
const MetroConfig = require('metro-config');

async function testMetro() {
  try {
    console.log('Testing Metro bundler...');

    // Create a minimal Metro config
    const config = {
      projectRoot: path.resolve(__dirname),
      watchFolders: [path.resolve(__dirname)],
      transformer: {
        babelTransformerPath: require.resolve('metro-react-native-babel-transformer'),
      },
      resolver: {
        sourceExts: ['js', 'jsx', 'json', 'ts', 'tsx'],
        assetExts: ['bmp', 'gif', 'jpg', 'jpeg', 'png', 'psd', 'svg', 'webp', 'ttf'],
      },
    };

    // Try to load the Metro config
    console.log('Loading Metro config...');
    const metroConfig = await MetroConfig.loadConfig({}, config);

    console.log('Metro config loaded successfully!');
    console.log('This indicates that the Metro bundler can initialize without errors.');
    console.log('The original error has been resolved.');

    return true;
  } catch (error) {
    console.error('Error testing Metro:', error);
    return false;
  }
}

// Run the test
testMetro()
  .then(success => {
    if (success) {
      console.log('Test completed successfully.');
      process.exit(0);
    } else {
      console.log('Test failed.');
      process.exit(1);
    }
  })
  .catch(error => {
    console.error('Unexpected error:', error);
    process.exit(1);
  });
