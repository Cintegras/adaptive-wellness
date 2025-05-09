import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";

// Try to import componentTagger, but don't fail if it's not compatible
let taggerPlugin = null;
try {
  const { componentTagger } = require("lovable-tagger");
  taggerPlugin = componentTagger;
} catch (error) {
  console.warn("Warning: lovable-tagger plugin could not be loaded. Development tagging will be disabled.");
  console.warn(error);
}

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
  },
  plugins: [
    react(),
    mode === 'development' && taggerPlugin && taggerPlugin(),
  ].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  test: {
    environment: 'happy-dom',
    setupFiles: './src/test/setup.ts',
    globals: true,
    css: true,
    coverage: {
      provider: 'istanbul',
      reporter: ['text', 'json', 'html'],
      statements: 80,
      branches: 75,
      functions: 80,
      lines: 80
    }
  }
}));
