module.exports = {
  env: {
    es6: true,
    node: true, // Enable Node.js global variables like 'module', 'require', 'exports'
    commonjs: true,
  },
  parserOptions: {
    ecmaVersion: 2020, // Modern JS syntax
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "off",
    "quotes": "off",
    "camelcase": "off",
    "max-len": ["warn", { "code": 200 }],
    "comma-dangle": "off",
    "object-curly-spacing": "off",
    "indent": "off",
  },
};
