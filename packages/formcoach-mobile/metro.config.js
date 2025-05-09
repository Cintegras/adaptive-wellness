// Learn more https://docs.expo.io/guides/customizing-metro
const path = require('path');

// Create a minimal custom config without relying on expo/metro-config
const config = {
  resolver: {
    sourceExts: ['js', 'jsx', 'json', 'ts', 'tsx'],
    assetExts: ['bmp', 'gif', 'jpg', 'jpeg', 'png', 'psd', 'svg', 'webp', 'ttf'],
    // Add any additional resolver options here
  },
  transformer: {
    babelTransformerPath: require.resolve('metro-react-native-babel-transformer'),
    assetRegistryPath: 'react-native/Libraries/Image/AssetRegistry',
    // Add any additional transformer options here
  },
  serializer: {
    // Provide a minimal serializer configuration
    getModulesRunBeforeMainModule: () => [],
    getPolyfills: () => [],
  },
  server: {
    port: 8081,
  },
  // Add project root
  projectRoot: path.resolve(__dirname),
  watchFolders: [path.resolve(__dirname)],
};

// Export the configuration
module.exports = config;
