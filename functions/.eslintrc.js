module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"], // Mantém regras específicas
    "prefer-arrow-callback": "off", // Permite callbacks normais
    "quotes": "off", // Desativa a regra de aspas
    "camelcase": "off", // Desativa a regra de camelCase
    "max-len": ["warn", { "code": 200 }], // Permite até 120 caracteres por linha (ou ajusta conforme necessário)
    "comma-dangle": "off", // Permite vírgulas finais opcionais
    "object-curly-spacing": "off", // Desativa espaço obrigatório em objetos
    "indent": "off", // Desativa regras de indentação rígidas
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
