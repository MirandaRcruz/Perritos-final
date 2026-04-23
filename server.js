const express = require('express');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 10000;

// Esto sirve tu app Flutter
app.use(express.static(path.join(__dirname, 'build/web')));

// Si alguien entra a cualquier ruta, carga la app
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});
